require 'ostruct'
require 'formula'
require 'options'
require 'vendor/multi_json'

# Inherit from OpenStruct to gain a generic initialization method that takes a
# hash and creates an attribute for each key and value. `Tab.new` probably
# should not be called directly, instead use one of the class methods like
# `Tab.create`.
class Tab < OpenStruct
  FILENAME = 'INSTALL_RECEIPT.json'

  def self.create f, args
    f.build.args = args

    sha = HOMEBREW_REPOSITORY.cd do
      `git rev-parse --verify -q HEAD 2>/dev/null`.chuzzle
    end

    Tab.new :used_options => f.build.used_options,
            :unused_options => f.build.unused_options,
            :tabfile => f.prefix.join(FILENAME),
            :built_as_bottle => !!ARGV.build_bottle?,
            :tapped_from => f.tap,
            :time => Time.now.to_i, # to_s would be better but Ruby has no from_s function :P
            :HEAD => sha
  end

  def self.from_file path
    tab = Tab.new MultiJson.decode(open(path).read)
    tab.tabfile = path
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

  def self.for_formula f
    f = Formula.factory(f)
    path = [f.opt_prefix, f.linked_keg].map{ |pn| pn.join(FILENAME) }.find{ |pn| pn.exist? }
    # Legacy kegs may lack a receipt. If it doesn't exist, fake one
    if path.nil? then self.dummy_tab(f) else self.from_file(path) end
  end

  def self.dummy_tab f=nil
    Tab.new :used_options => [],
            :unused_options => (f.build.as_flags rescue []),
            :built_as_bottle => false,
            :tapped_from => "",
            :time => nil,
            :HEAD => nil
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

  def to_json
    MultiJson.encode({
      :used_options => used_options.to_a,
      :unused_options => unused_options.to_a,
      :built_as_bottle => built_as_bottle,
      :tapped_from => tapped_from,
      :time => time,
      :HEAD => send("HEAD")})
  end

  def write
    tabfile.write to_json
  end
end
