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
    formula_options = f.options.map { |o, _| o }

    Tab.new :used_options => formula_options & arg_options,
            :unused_options => formula_options - arg_options,
            :tabfile => f.prefix + 'INSTALL_RECEIPT.json'
  end

  def to_json
    MultiJson.encode({
      :used_options => used_options,
      :unused_options => unused_options
    })
  end

  def write
    tabfile.write to_json
  end
end
