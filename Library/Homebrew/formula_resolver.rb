require "pathname"

# Return actual name of some formula at commit commit

class FormulaResolver
  attr_reader :sheets
  @sheets = {}

  class Entry
    attr_reader :name, :commit

    def initialize(name, commit)
      @name = name
      @commit = commit
    end

    # TODO add smart comparator and add exception handling
    def <=> (entry)
      commit <=> entry.commit
    end

    # TODO what if str has bad format? can check using regex
    def self.parse_from_string(str)
      Entry.new *str.chomp.split(',').each { |e| e.lstrip! }
    end
  end

  class Sheet
    attr_reader :entries
    attr_reader :last_sarched_index

    def initialize(name)
      @name = name
      @entries = []
      File.open(HOMEBREW_LIBRARY/"Homebrew/Renames/#{name}").each do |line|
        entries << Entry.new(*line.chomp.split(',').map(&:lstrip))
      end
    end

    def entry_after(other)
      # TODO change linear search to binary
      entries.detect { |e| e > other }
    end

    def name_after(other)
      entry_after(other).name
    end
  end

  def resolve_name(name, commit)
    result_entry = Entry.new(name, commit)
    while next_entry = sheets[result_entry.name].entry_after(result_entry)
      result_entry = next_entry
    end
    result_entry.name
  end
end
