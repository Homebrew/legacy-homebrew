require "pathname"

# Return actual name of some formula at commit commit

class FormulaResolver

  # {Entry} is used to store one entry from renames file
  # entry in file is a string `newname, commit`
  class Entry
    include Comparable

    attr_reader :name, :commit

    def initialize(name, commit)
      puts "Entry initialized with #{name}, #{commit}"
      @name = name
      @commit = commit
    end

    def <=>(entry)
      puts "compare #{commit} and #{entry.commit}"
      return 0 if commit == entry.commit
      if commit == 0
        return -1
      elsif entry.commit == 0
        return 1
      else
        `git merge-base --is-ancestor #{commit} #{entry.commit}`.chomp
        if $?.success?
          puts "success"
          return -1
        else
          puts "not okay"
          return 1
        end
      end
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

    attr_reader :user, :repo

    def initialize(name, user="Homebrew", repo="homebrew")
      puts "Starting initializing Sheet..."
      @name = name
      @user = user
      @repo = repo
      @entries = []
      entry_file = if user == "Homebrew" && repo == "homebrew"
        HOMEBREW_LIBRARY.join("Renames/#{name}")
      else
        HOMEBREW_LIBRARY.join("Taps/#{user}/homebrew-#{repo}/Renames/#{name}")
      end

      if entry_file.file?
        File.open(entry_file).each do |line|
          entries << Entry.new(*line.chomp.split(',').map(&:lstrip))
        end
      end
      puts "Sheet initialize #{name}"
      puts "entries are #{entries}"
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
  attr_reader :name

  # formula renames hashes for resolving current name of the formula
  attr_reader :sheets

  # first commit we resolve formula after
  attr_reader :start_point_commit

  # user and repository for formula
  attr_reader :user, :repo

  def initialize(name, start_point_commit=nil)
    puts "initialize FormulaResolver #{name}, #{start_point_commit}"
    @sheets = Hash.new

    if name.include?("/")
      @user, @repo, @name = name.split("/", 3).map(&:downcase)
    else
      @user, @repo, @name = "Homebrew", "homebrew", name
    end

    @start_point_commit = start_point_commit || get_installed_commit
    @sheets[name] = Sheet.new(name, user, repo)
  end

  # returns nil if there are no renames for this formula after start_point_commit
  # NOTE if formula renamed from X to X we don't treat it like renamed formula
  # TODO specify what to do when this happens
  def resolved_name
    puts "in resolved name"
    puts start_point_commit
    if start_point_commit
      previous_entry = Entry.new(name, start_point_commit)
      puts previous_entry
      while (sheets[previous_entry.name] &&
          current_entry = sheets[previous_entry.name].entry_after(previous_entry))
        puts "current_entry.name is #{current_entry.name}"
        previous_entry = current_entry
        sheets[previous_entry.name] ||= Sheet.new(previous_entry.name, user, repo)
      end
      previous_entry.name
    else
      name
    end
  end

  # get the commit of installed formula with that name, which will be stored
  # in INSTALL_RECEIPT or some othe file
  # `git rev-list -1 origin/master path/to/formula`
  # TODO specify where to store that commit
  # TODO write the commit for the formula, when we install it
  # TODO write a corresponding comment in install/updgrade and commands that
  # reinstalls package
  # TODO implement method

  def get_installed_commit
    if (dir = HOMEBREW_CELLAR.join(name)).exist? && keg_dir = dir.subdirs.first
      tab = Tab.for_keg(Keg.new(keg_dir))
      tab.last_commit if tab.source["tap"].downcase == "#{user}/#{repo}".downcase
    end
  end

  def self.for_name(name)
    FormulaResolver.new(name)
  end
end
