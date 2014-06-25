require 'cxxstdlib'
require 'ostruct'
require 'options'
require 'utils/json'

# Inherit from OpenStruct to gain a generic initialization method that takes a
# hash and creates an attribute for each key and value. `Tab.new` probably
# should not be called directly, instead use one of the class methods like
# `Tab.create`.
class Tab < OpenStruct
  FILENAME = 'INSTALL_RECEIPT.json'

  def self.create f, compiler, stdlib, args
    build = f.build.dup
    build.args = args

    sha = HOMEBREW_REPOSITORY.cd do
      `git rev-parse --verify -q HEAD 2>/dev/null`.chuzzle
    end

    Tab.new :used_options => build.used_options,
            :unused_options => build.unused_options,
            :tabfile => f.prefix.join(FILENAME),
            :built_as_bottle => !!ARGV.build_bottle?,
            :poured_from_bottle => false,
            :tapped_from => f.tap,
            :time => Time.now.to_i,
            :HEAD => sha,
            :compiler => compiler,
            :stdlib => stdlib
  end

  def self.from_file path
    tab = Tab.new Utils::JSON.load(File.read(path))
    tab.tabfile = path.realpath
    tab
  end

  def self.for_keg keg
    path = keg.join(FILENAME)

    if path.exist?
      self.from_file(path)
    else
      self.dummy_tab
    end
  end

  def self.for_name name
    for_formula(Formulary.factory(name))
  end

  def self.for_formula f
    paths = [f.opt_prefix, f.linked_keg]

    if f.rack.directory? && (dirs = f.rack.subdirs).length == 1
      paths << dirs.first
    end

    paths << f.prefix

    path = paths.map { |pn| pn.join(FILENAME) }.find(&:file?)

    if path
      from_file(path)
    else
      dummy_tab(f)
    end
  end

  def self.dummy_tab f=nil
    Tab.new :used_options => [],
            :unused_options => (f.build.as_flags rescue []),
            :built_as_bottle => false,
            :poured_from_bottle => false,
            :tapped_from => "",
            :time => nil,
            :HEAD => nil,
            :compiler => :clang
  end

  def with? name
    if options.include? "with-#{name}"
      used_options.include? "with-#{name}"
    elsif options.include? "without-#{name}"
      not used_options.include? "without-#{name}"
    else
      false
    end
  end

  def include? opt
    used_options.include? opt
  end

  def universal?
    used_options.include? "universal"
  end

  def used_options
    Options.coerce(super)
  end

  def unused_options
    Options.coerce(super)
  end

  def options
    used_options + unused_options
  end

  def cxxstdlib
    # Older tabs won't have these values, so provide sensible defaults
    lib = stdlib.to_sym if stdlib
    cc = compiler || MacOS.default_compiler
    CxxStdlib.new(lib, cc.to_sym)
  end

  def to_json
    Utils::JSON.dump({
      :used_options => used_options.map(&:to_s),
      :unused_options => unused_options.map(&:to_s),
      :built_as_bottle => built_as_bottle,
      :poured_from_bottle => poured_from_bottle,
      :tapped_from => tapped_from,
      :time => time,
      :HEAD => self.HEAD,
      :stdlib => (stdlib.to_s if stdlib),
      :compiler => (compiler.to_s if compiler)})
  end

  def write
    tabfile.atomic_write(to_json)
  end

  def to_s
    s = []
    case poured_from_bottle
    when true  then s << "Poured from bottle"
    when false then s << "Built from source"
    end
    unless used_options.empty?
      s << "Installed" if s.empty?
      s << "with:"
      s << used_options.to_a.join(", ")
    end
    s.join(" ")
  end
end
