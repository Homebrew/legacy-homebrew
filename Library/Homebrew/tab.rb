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

  def self.create(formula, compiler, stdlib, build)
    Tab.new :used_options => build.used_options,
            :unused_options => build.unused_options,
            :tabfile => formula.prefix.join(FILENAME),
            :built_as_bottle => !!ARGV.build_bottle?,
            :poured_from_bottle => false,
            :tapped_from => formula.tap,
            :time => Time.now.to_i,
            :HEAD => Homebrew.git_head,
            :compiler => compiler,
            :stdlib => stdlib
  end

  def self.from_file path
    attributes = Utils::JSON.load(File.read(path))
    attributes[:tabfile] = path
    new(attributes)
  end

  def self.for_keg keg
    path = keg.join(FILENAME)

    if path.exist?
      from_file(path)
    else
      dummy_tab
    end
  end

  def self.for_name name
    for_formula(Formulary.factory(name))
  end

  def self.for_formula f
    paths = []

    if f.opt_prefix.symlink? && f.opt_prefix.directory?
      paths << f.opt_prefix.resolved_path
    end

    if f.linked_keg.symlink? && f.linked_keg.directory?
      paths << f.linked_keg.resolved_path
    end

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
            :stdlib => nil,
            :compiler => :clang
  end

  def with? name
    if options.include? "with-#{name}"
      include? "with-#{name}"
    elsif options.include? "without-#{name}"
      not include? "without-#{name}"
    else
      false
    end
  end

  def without? name
    not with? name
  end

  def include? opt
    used_options.include? opt
  end

  def universal?
    include?("universal")
  end

  def cxx11?
    include?("c++11")
  end

  def build_32_bit?
    include?("32-bit")
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
    CxxStdlib.create(lib, cc.to_sym)
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
