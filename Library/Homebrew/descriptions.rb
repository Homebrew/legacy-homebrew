require 'formula'

# TODO: Add support for full names.

class Descriptions
  def self.get(names)
    descriptions = {}

    names.inject({}) do |descriptions, name|
      formula = Formulary.factory(name)
      descriptions[formula.name] = formula.desc
      descriptions
    end
  end


  def self.print(names)
    descriptions = self.get(names)
    max_len = descriptions.keys.map(&:length).max
    template = "%#{max_len}s: %s\n"

    descriptions.each do |name, desc|
      printf(template, name, desc)
    end
  end

end
