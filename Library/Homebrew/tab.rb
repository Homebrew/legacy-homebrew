require "cxxstdlib"
require "ostruct"
require "options"
require "utils/json"

# Inherit from OpenStruct to gain a generic initialization method that takes a
# hash and creates an attribute for each key and value. `Tab.new` probably
# should not be called directly, instead use one of the class methods like
# `Tab.create`.
class Tab < OpenStruct
  FILENAME = "INSTALL_RECEIPT.json"
  CACHE = {}

  def self.clear_cache
    CACHE.clear
  end

  def self.create(formula, compiler, stdlib, build, source_modified_time)
    attributes = {
      "used_options" => build.used_options.as_flags,
      "unused_options" => build.unused_options.as_flags,
      "tabfile" => formula.prefix.join(FILENAME),
      "built_as_bottle" => build.bottle?,
      "poured_from_bottle" => false,
      "time" => Time.now.to_i,
      "source_modified_time" => source_modified_time.to_i,
      "HEAD" => Homebrew.git_head,
      "compiler" => compiler,
      "stdlib" => stdlib,
      "source" => {
        "path" => formula.path.to_s,
        "tap" => formula.tap ? formula.tap.name : nil,
        "spec" => formula.active_spec_sym.to_s
      }
    }

    new(attributes)
  end

  def self.from_file(path)
    CACHE.fetch(path) { |p| CACHE[p] = from_file_content(File.read(p), p) }
  end

  def self.from_file_content(content, path)
    attributes = Utils::JSON.load(content)
    attributes["tabfile"] = path
    attributes["source_modified_time"] ||= 0
    attributes["source"] ||= {}

    tapped_from = attributes["tapped_from"]
    unless tapped_from.nil? || tapped_from == "path or URL"
      attributes["source"]["tap"] = attributes.delete("tapped_from")
    end

    if attributes["source"]["tap"] == "mxcl/master"
      attributes["source"]["tap"] = "Homebrew/homebrew"
    end

    if attributes["source"]["spec"].nil?
      version = PkgVersion.parse path.to_s.split("/")[-2]
      if version.head?
        attributes["source"]["spec"] = "head"
      else
        attributes["source"]["spec"] = "stable"
      end
    end

    new(attributes)
  end

  def self.for_keg(keg)
    path = keg.join(FILENAME)

    if path.exist?
      from_file(path)
    else
      empty
    end
  end

  def self.for_name(name)
    for_formula(Formulary.factory(name))
  end

  def self.remap_deprecated_options(deprecated_options, options)
    deprecated_options.each do |deprecated_option|
      option = options.find { |o| o.name == deprecated_option.old }
      next unless option
      options -= [option]
      options << Option.new(deprecated_option.current, option.description)
    end
    options
  end

  def self.for_formula(f)
    paths = []

    if f.opt_prefix.symlink? && f.opt_prefix.directory?
      paths << f.opt_prefix.resolved_path
    end

    if f.linked_keg.symlink? && f.linked_keg.directory?
      paths << f.linked_keg.resolved_path
    end

    if (dirs = f.installed_prefixes).length == 1
      paths << dirs.first
    end

    paths << f.prefix

    path = paths.map { |pn| pn.join(FILENAME) }.find(&:file?)

    if path
      tab = from_file(path)
      used_options = remap_deprecated_options(f.deprecated_options, tab.used_options)
      tab.used_options = used_options.as_flags
    else
      tab = empty
      tab.unused_options = f.options.as_flags
      tab.source = {
        "path" => f.path.to_s,
        "tap" => f.tap ? f.tap.name : f.tap,
        "spec" => f.active_spec_sym.to_s,
      }
    end

    tab
  end

  def self.empty
    attributes = {
      "used_options" => [],
      "unused_options" => [],
      "built_as_bottle" => false,
      "poured_from_bottle" => false,
      "time" => nil,
      "source_modified_time" => 0,
      "HEAD" => nil,
      "stdlib" => nil,
      "compiler" => "clang",
      "source" => {
        "path" => nil,
        "tap" => nil,
        "spec" => "stable"
      }
    }

    new(attributes)
  end

  def with?(val)
    option_names = val.respond_to?(:option_names) ? val.option_names : [val]

    option_names.any? do |name|
      include?("with-#{name}") || unused_options.include?("without-#{name}")
    end
  end

  def without?(val)
    !with?(val)
  end

  def include?(opt)
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
    Options.create(super)
  end

  def unused_options
    Options.create(super)
  end

  def compiler
    super || MacOS.default_compiler
  end

  def cxxstdlib
    # Older tabs won't have these values, so provide sensible defaults
    lib = stdlib.to_sym if stdlib
    CxxStdlib.create(lib, compiler.to_sym)
  end

  def build_bottle?
    built_as_bottle && !poured_from_bottle
  end

  def bottle?
    built_as_bottle
  end

  def tap
    tap_name = source["tap"]
    Tap.fetch(tap_name) if tap_name
  end

  def tap=(tap)
    tap_name = tap.respond_to?(:name) ? tap.name : tap
    source["tap"] = tap_name
  end

  def spec
    source["spec"].to_sym
  end

  def source_modified_time
    Time.at(super)
  end

  def to_json
    attributes = {
      "used_options" => used_options.as_flags,
      "unused_options" => unused_options.as_flags,
      "built_as_bottle" => built_as_bottle,
      "poured_from_bottle" => poured_from_bottle,
      "time" => time,
      "source_modified_time" => source_modified_time.to_i,
      "HEAD" => self.HEAD,
      "stdlib" => (stdlib.to_s if stdlib),
      "compiler" => (compiler.to_s if compiler),
      "source" => source
    }

    Utils::JSON.dump(attributes)
  end

  def write
    CACHE[tabfile] = self
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
      s << used_options.to_a.join(" ")
    end
    s.join(" ")
  end
end
