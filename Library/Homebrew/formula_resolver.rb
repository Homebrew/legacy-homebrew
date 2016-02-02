require "tap"

class FormulaResolver
  class FormulaResolverDifferentTapsError < RuntimeError
    def initialize(name, tap, rack_tap)
      super <<-EOS.undent
      Can't resolve #{name} from rack because rack is from #{rack_tap ? rack_tap : "path or url"}, but #{name} is from #{tap}.
      EOS
    end
  end

  class FormulaResolverNoRack < RuntimeError
    def initialize(name)
      super "#{name} can't be resolved from rack, because it doesn't exist."
    end
  end

  # {Entry} is used to store one entry from renames file
  # entry in file is a string `newname, commit`
  class Entry
    include Comparable

    attr_reader :name, :tap, :commit

    def initialize(name, user, repo, commit)
      puts "Entry initialized with #{name}, #{commit}"
      @name = name
      @tap = Tap.fetch(user, repo)
      @commit = commit
    end

    def <=>(entry)
      puts "compare #{commit} and #{entry.commit}"
      # TODO update for nil commits
      if commit.nil?
        return -1
      elsif commit == entry.commit
        return 0
      else
        tap.path.cd do
          # TODO Utils.popen_read ?
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
    end

    # TODO what if str has bad format? can check using regex
    def self.parse_from_line(line, user, repo)
      name, commit = line.chomp.split(',').each { |e| e.lstrip! }
      Entry.new(name, user, repo, commit)
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

    def initialize(name, user="homebrew", repo="homebrew")
      puts "Initializing Sheet for #{name}, #{user}, #{repo}..."
      @name = name
      @user = user
      @repo = repo
      @entries = []
      entry_file = if user == "homebrew" && repo == "homebrew"
        HOMEBREW_LIBRARY.join("Renames/#{name}")
      else
        HOMEBREW_LIBRARY.join("Taps/#{user}/homebrew-#{repo}/Renames/#{name}")
      end

      if entry_file.file?
        File.open(entry_file).each do |line|
          entries << Entry.parse_from_line(line, user, repo)
        end
      end
      puts "Sheet initialized #{name}"
      puts "entries are #{entries}"
    end

    # get the first entry after another entry
    def entry_after(other)
      # TODO change linear search to binary
      # ans_entry = entries.last
      # ans_index = entries.size
      # l  = 0
      # r = entries.size - 1
      # while (l <= r)
      #   m = (l + r) / 2
      #   if (entries[m] >= other)
      #     if (m < ans_index)
      #       ans_index = m
      #       ans_entry = entries[m]
      #     end
      #     r = m - 1
      #   else
      #     l = m + 1
      #   end
      # end
      # ans_entry if ans_index < entries.size
      entries.detect { |e| e >= other }
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

  def initialize(name, user="homebrew", repo="homebrew", start_point_commit=nil)
    @name = name
    @user = user
    @repo = repo
    puts "initialize FormulaResolver #{name}, #{start_point_commit}"
    @sheets = Hash.new

    @start_point_commit = start_point_commit
    @sheets[@name] = Sheet.new(@name, user, repo)
  end

  # TODO what if there are no renames for this formula after start_point_commit
  # NOTE if formula renamed from X to X we don't treat it like renamed formula
  # TODO specify what to do when this happens
  def resolved_name
    if start_point_commit
      previous_entry = Entry.new(name, user, repo, start_point_commit)
      puts previous_entry
      while (sheets[previous_entry.name] &&
          current_entry = sheets[previous_entry.name].entry_after(previous_entry))
        puts "current_entry.name is #{current_entry.name}"
        previous_entry = current_entry
        sheets[previous_entry.name] ||= Sheet.new(previous_entry.name, user, repo)
      end
      if user == "homebrew" && repo == "homebrew"
        previous_entry.name
      else
        "#{user}/#{repo}/#{previous_entry.name}"
      end
    else
      if user == "homebrew" && repo == "homebrew"
        name
      else
        "#{user}/#{repo}/#{name}"
      end
    end
  end

  # TODO what if bad commit passed?
  def self.resolve_from_commit(name, commit)
    user, repo, name = split_name(name)
    FormulaResolver.new(name, user, repo, commit).resolved_name
  end

  def self.resolve_from_rack(name)
    user, repo, name = split_name(name)
    installed_commit = get_installed_commit(name, user, repo) \
      || get_first_repository_commit(user, repo)
    FormulaResolver.new(name, user, repo, installed_commit).resolved_name
  end

  def self.resolve_for_name(name)
    user, repo, name = split_name(name)
    start_point_commit = begin
      get_installed_commit(name, user, repo)
    rescue FormulaResolverDifferentTapsError, FormulaResolverNoRack
    end
    start_point_commit ||= get_first_repository_commit(user, repo)
    FormulaResolver.new(name, user, repo, start_point_commit).resolved_name
  end

  def self.split_name(name)
    name.downcase!
    if name.include?("/")
      name.split("/")
    else
      ["homebrew", "homebrew", name]
    end
  end

  # Get the commit assigned to installed keg for that name.
  def self.get_installed_commit(name, user, repo)
    unless (dir = HOMEBREW_CELLAR.join(name)).exist? && keg_dir = dir.subdirs.first
      raise FormulaResolverNoRack.new(name)
    end

    tab = Tab.for_keg(Keg.new(keg_dir))
    tap = tab.tap
    puts "tap is #{tap}"
    if tap && tap.name.downcase == "#{user}/#{repo}"
      tab.last_commit
    else
      raise FormulaResolverDifferentTapsError.new(name, Tap.fetch(user,repo), tap)
    end
  end

  # TODO cache?
  def self.get_first_repository_commit(user, repo)
    tap = Tap.fetch(user, repo)
    if tap.git?
      tap.path.cd do
        Utils.popen_read("git", "rev-list", "--max-parents=0", "HEAD").split.last
      end
    end
  end
end
