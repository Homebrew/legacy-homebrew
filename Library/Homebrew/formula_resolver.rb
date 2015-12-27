require "pathname"

# Return actual name of some formula at commit commit

class FormulaResolver

  # {Entry} is used to store one entry in from renames file
  # entry in file is a string `newname, commit`
  class Entry
    include Comparable

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

  # {Sheet} is a class for storing formula_renams
  # entries grouped be one renames file
  # entry_after and name_after find the nearest rename after given entry
  class Sheet
    # name of the for renames of formula with that name
    attr_reader :name

    # entries from renames file
    attr_reader :entries

    # last searched index in the sheet
    # TODO remove or implement
    attr_reader :last_sarched_index

    def initialize(name)
      @name = name
      @entries = []
      File.open(HOMEBREW_LIBRARY/"Homebrew/Renames/#{name}").each do |line|
        entries << Entry.new(*line.chomp.split(',').map(&:lstrip))
      end
    end

    # get the first entry after another entry
    def entry_after(other)
      # TODO change linear search to binary
      entries.detect { |e| e > other }
    end

    # get the first name after given entry
    def name_after(other)
      entry_after(other).name
    end
  end

  # name of the formula to be resolved
  attr_reader :formula_name

  # formula renames hashes for resolving current name of the formula
  attr_reader :sheets

  def resolve_name(name, commit)
    result_entry = Entry.new(name, commit)
    while next_entry = sheets[result_entry.name].entry_after(result_entry)
      result_entry = next_entry
    end
    result_entry.name
  end

  def initialize(formula_name)
    @sheets = Hash.new
    @formula_name = formula_name
    @sheets[formula_name] = Sheet.new(formula_name)
  end

  def resolved_name
    previous_entry = Entry.new(formula_name, get_installed_commit)
    while (current_entry = sheets[previous_name].entry_after(previous_entry))
      previous_entry = current_entry
      sheets[pervious_entry] ||= Sheet.new(previous_entry.name)
    end
    previous_entry.name
  end

  # get the commit of installed formula with that name, which will be stored
  # in INSTALLED_RECEIPT or some othe file
  # `git rev-list -1 origin/master path/to/formula`
  # TODO specify where to store that commit
  # TODO write the commit for the formula, when we install it
  # TODO write a corresponding comment in install/updgrade and commands that
  # reinstalls package
  # TODO implement method

  def get_installed_commit
    HOMEBREW_CELLAR.join("#{formula_name}/LAST_COMMIT").read.chomp
  end

  def self.for_name(formula_name)
    FormulaResolver.new(formula_name)
  end

end
