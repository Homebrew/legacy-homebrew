require 'ostruct'

require 'formula'
require 'vendor/multi_json'

# Inherit from OpenStruct to gain a generic initialization method that takes a
# hash and creates an attribute for each key and value. `Tab.new` probably
# should not be called directly, instead use one of the class methods like
# `Tab.for_install`.
class Tab < OpenStruct
  def self.for_install f, args
    # Retrieve option flags from command line.
    arg_options = args.options_only
    # Pick off the option flags from the formula's `options` array by
    # discarding the descriptions.
    formula_options = f.build.map { |opt, _| "--#{opt}" }

    Tab.new :used_options => formula_options & arg_options,
            :unused_options => formula_options - arg_options,
            :tabfile => f.prefix + "INSTALL_RECEIPT.json",
            :built_bottle => !!args.build_bottle?,
            :tapped_from => f.tap
  end

  def self.from_file path
    tab = Tab.new MultiJson.decode(open(path).read)
    tab.tabfile = path

    return tab
  end

  def self.for_keg keg
    path = keg+'INSTALL_RECEIPT.json'

    if path.exist?
      self.from_file path
    else
      begin
        self.dummy_tab Formula.factory(keg.parent.basename)
      rescue FormulaUnavailableError
        Tab.new :used_options => [],
                :unused_options => [],
                :built_bottle => false,
                :tapped_from => ""
      end
    end
  end

  def self.for_formula f
    f = Formula.factory f unless f.kind_of? Formula
    path = f.linked_keg/'INSTALL_RECEIPT.json'

    if path.exist?
      self.from_file path
    else
      # Really should bail out with an error if a formula was not installed
      # with a Tab. However, there will be lots of legacy installs that have no
      # receipt---so we fabricate one that claims the formula was installed with
      # no options.
      #
      # TODO:
      # This isn't the best behavior---perhaps a future version of Homebrew can
      # treat missing Tabs as errors.
      self.dummy_tab f
    end
  end

  def self.dummy_tab f
    Tab.new :used_options => [],
            :unused_options => f.build.map { |opt, _| "--#{opt}" },
            :built_bottle => false,
            :tapped_from => ""
  end

  def installed_with? opt
    used_options.include? opt
  end

  def options
    used_options + unused_options
  end

  def to_json
    MultiJson.encode({
      :used_options => used_options,
      :unused_options => unused_options,
      :built_bottle => built_bottle,
      :tapped_from => tapped_from
    })
  end

  def write
    tabfile.write to_json
  end
end
