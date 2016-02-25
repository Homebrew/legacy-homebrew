require "extend/string"

# a {Tap} is used to extend the formulae provided by Homebrew core.
# Usually, it's synced with a remote git repository. And it's likely
# a Github repository with the name of `user/homebrew-repo`. In such
# case, `user/repo` will be used as the {#name} of this {Tap}, where
# {#user} represents Github username and {#repo} represents repository
# name without leading `homebrew-`.
class Tap
  TAP_DIRECTORY = HOMEBREW_LIBRARY/"Taps"

  CACHE = {}

  def self.clear_cache
    CACHE.clear
  end

  def self.fetch(*args)
    case args.length
    when 1
      user, repo = args.first.split("/", 2)
    when 2
      user = args[0]
      repo = args[1]
    end

    raise "Invalid tap name" unless user && repo

    # we special case homebrew so users don't have to shift in a terminal
    user = "Homebrew" if user == "homebrew"
    repo = repo.strip_prefix "homebrew-"

    if user == "Homebrew" && repo == "homebrew"
      require "core_formula_repository"
      return CoreFormulaRepository.instance
    end

    cache_key = "#{user}/#{repo}".downcase
    CACHE.fetch(cache_key) { |key| CACHE[key] = Tap.new(user, repo) }
  end

  extend Enumerable

  # The user name of this {Tap}. Usually, it's the Github username of
  # this #{Tap}'s remote repository.
  attr_reader :user

  # The repository name of this {Tap} without leading `homebrew-`.
  attr_reader :repo

  # The name of this {Tap}. It combines {#user} and {#repo} with a slash.
  # {#name} is always in lowercase.
  # e.g. `user/repo`
  attr_reader :name

  # The local path to this {Tap}.
  # e.g. `/usr/local/Library/Taps/user/homebrew-repo`
  attr_reader :path

  # @private
  def initialize(user, repo)
    @user = user
    @repo = repo
    @name = "#{@user}/#{@repo}".downcase
    @path = TAP_DIRECTORY/"#{@user}/homebrew-#{@repo}".downcase
  end

  # clear internal cache
  def clear_cache
    @remote = nil
    @formula_dir = nil
    @formula_files = nil
    @alias_files = nil
    @aliases = nil
    @alias_table = nil
    @alias_reverse_table = nil
    @command_files = nil
    @formula_renames = nil
    @tap_migrations = nil
  end

  # The remote path to this {Tap}.
  # e.g. `https://github.com/user/homebrew-repo`
  def remote
    @remote ||= if installed?
      if git?
        path.cd do
          Utils.popen_read("git", "config", "--get", "remote.origin.url").chomp
        end
      end
    else
      raise TapUnavailableError, name
    end
  end

  # True if this {Tap} is a git repository.
  def git?
    (path/".git").exist?
  end

  # The issues URL of this {Tap}.
  # e.g. `https://github.com/user/homebrew-repo/issues`
  def issues_url
    if official? || !custom_remote?
      "https://github.com/#{user}/homebrew-#{repo}/issues"
    end
  end

  def to_s
    name
  end

  # True if this {Tap} is an official Homebrew tap.
  def official?
    user == "Homebrew"
  end

  # True if the remote of this {Tap} is a private repository.
  def private?
    return true if custom_remote?
    GitHub.private_repo?(user, "homebrew-#{repo}")
  rescue GitHub::HTTPNotFoundError
    true
  rescue GitHub::Error
    false
  end

  # True if this {Tap} has been installed.
  def installed?
    path.directory?
  end

  # @private
  def core_formula_repository?
    false
  end

  # install this {Tap}.
  #
  # @param [Hash] options
  # @option options [String]  :clone_targe If passed, it will be used as the clone remote.
  # @option options [Boolean] :full_clone If set as true, full clone will be used.
  def install(options = {})
    require "descriptions"
    raise TapAlreadyTappedError, name if installed?
    clear_cache

    # ensure git is installed
    Utils.ensure_git_installed!
    ohai "Tapping #{name}"
    remote = options[:clone_target] || "https://github.com/#{user}/homebrew-#{repo}"
    args = %W[clone #{remote} #{path}]
    args << "--depth=1" unless options.fetch(:full_clone, false)

    begin
      safe_system "git", *args
    rescue Interrupt, ErrorDuringExecution
      ignore_interrupts do
        sleep 0.1 # wait for git to cleanup the top directory when interrupt happens.
        path.parent.rmdir_if_possible
      end
      raise
    end

    link_manpages

    formula_count = formula_files.size
    puts "Tapped #{formula_count} formula#{plural(formula_count, "e")} (#{path.abv})"
    Descriptions.cache_formulae(formula_names)

    if !options[:clone_target] && private?
      puts <<-EOS.undent
        It looks like you tapped a private repository. To avoid entering your
        credentials each time you update, you can use git HTTP credential
        caching or issue the following command:
          cd #{path}
          git remote set-url origin git@github.com:#{user}/homebrew-#{repo}.git
      EOS
    end
  end

  def link_manpages
    return unless (path/"man").exist?
    conflicts = []
    (path/"man").find do |src|
      next if src.directory?
      dst = HOMEBREW_PREFIX/"share"/src.relative_path_from(path)
      next if dst.symlink? && src == dst.resolved_path
      if dst.exist?
        conflicts << dst
        next
      end
      dst.make_relative_symlink(src)
    end
    unless conflicts.empty?
      onoe <<-EOS.undent
        Could not link #{name} manpages to:
          #{conflicts.join("\n")}

        Please delete these files and run `brew tap --repair`.
      EOS
    end
  end

  # uninstall this {Tap}.
  def uninstall
    require "descriptions"
    raise TapUnavailableError, name unless installed?

    puts "Untapping #{name}... (#{path.abv})"
    unpin if pinned?
    formula_count = formula_files.size
    Descriptions.uncache_formulae(formula_names)
    unlink_manpages
    path.rmtree
    path.parent.rmdir_if_possible
    puts "Untapped #{formula_count} formula#{plural(formula_count, "e")}"
    clear_cache
  end

  def unlink_manpages
    return unless (path/"man").exist?
    (path/"man").find do |src|
      next if src.directory?
      dst = HOMEBREW_PREFIX/"share"/src.relative_path_from(path)
      dst.delete if dst.symlink? && src == dst.resolved_path
      dst.parent.rmdir_if_possible
    end
  end

  # True if the {#remote} of {Tap} is customized.
  def custom_remote?
    return true unless remote
    remote.casecmp("https://github.com/#{user}/homebrew-#{repo}") != 0
  end

  # path to the directory of all {Formula} files for this {Tap}.
  def formula_dir
    @formula_dir ||= [path/"Formula", path/"HomebrewFormula", path].detect(&:directory?)
  end

  # an array of all {Formula} files of this {Tap}.
  def formula_files
    @formula_files ||= if formula_dir
      formula_dir.children.select { |p| p.extname == ".rb" }
    else
      []
    end
  end

  # return true if given path would present a {Formula} file in this {Tap}.
  # accepts both absolute path and relative path (relative to this {Tap}'s path)
  # @private
  def formula_file?(file)
    file = Pathname.new(file) unless file.is_a? Pathname
    file = file.expand_path(path)
    file.extname == ".rb" && file.parent == formula_dir
  end

  # an array of all {Formula} names of this {Tap}.
  def formula_names
    @formula_names ||= formula_files.map { |f| formula_file_to_name(f) }
  end

  # path to the directory of all alias files for this {Tap}.
  # @private
  def alias_dir
    path/"Aliases"
  end

  # an array of all alias files of this {Tap}.
  # @private
  def alias_files
    @alias_files ||= Pathname.glob("#{alias_dir}/*").select(&:file?)
  end

  # an array of all aliases of this {Tap}.
  # @private
  def aliases
    @aliases ||= alias_files.map { |f| alias_file_to_name(f) }
  end

  # a table mapping alias to formula name
  # @private
  def alias_table
    return @alias_table if @alias_table
    @alias_table = Hash.new
    alias_files.each do |alias_file|
      @alias_table[alias_file_to_name(alias_file)] = formula_file_to_name(alias_file.resolved_path)
    end
    @alias_table
  end

  # a table mapping formula name to aliases
  # @private
  def alias_reverse_table
    return @alias_reverse_table if @alias_reverse_table
    @alias_reverse_table = Hash.new
    alias_table.each do |alias_name, formula_name|
      @alias_reverse_table[formula_name] ||= []
      @alias_reverse_table[formula_name] << alias_name
    end
    @alias_reverse_table
  end

  # an array of all commands files of this {Tap}.
  def command_files
    @command_files ||= Pathname.glob("#{path}/cmd/brew-*").select(&:executable?)
  end

  # path to the pin record for this {Tap}.
  # @private
  def pinned_symlink_path
    HOMEBREW_LIBRARY/"PinnedTaps/#{name}"
  end

  # True if this {Tap} has been pinned.
  def pinned?
    return @pinned if instance_variable_defined?(:@pinned)
    @pinned = pinned_symlink_path.directory?
  end

  # pin this {Tap}.
  def pin
    raise TapUnavailableError, name unless installed?
    raise TapPinStatusError.new(name, true) if pinned?
    pinned_symlink_path.make_relative_symlink(path)
    @pinned = true
  end

  # unpin this {Tap}.
  def unpin
    raise TapUnavailableError, name unless installed?
    raise TapPinStatusError.new(name, false) unless pinned?
    pinned_symlink_path.delete
    pinned_symlink_path.parent.rmdir_if_possible
    pinned_symlink_path.parent.parent.rmdir_if_possible
    @pinned = false
  end

  def to_hash
    hash = {
      "name" => name,
      "user" => user,
      "repo" => repo,
      "path" => path.to_s,
      "installed" => installed?,
      "official" => official?,
      "formula_names" => formula_names,
      "formula_files" => formula_files.map(&:to_s),
      "command_files" => command_files.map(&:to_s),
      "pinned" => pinned?
    }

    if installed?
      hash["remote"] = remote
      hash["custom_remote"] = custom_remote?
    end

    hash
  end

  # Hash with tap formula renames
  def formula_renames
    require "utils/json"

    @formula_renames ||= if (rename_file = path/"formula_renames.json").file?
      Utils::JSON.load(rename_file.read)
    else
      {}
    end
  end

  # Hash with tap migrations
  def tap_migrations
    require "utils/json"

    @tap_migrations ||= if (migration_file = path/"tap_migrations.json").file?
      Utils::JSON.load(migration_file.read)
    else
      {}
    end
  end

  def ==(other)
    other = Tap.fetch(other) if other.is_a?(String)
    self.class == other.class && self.name == other.name
  end

  def self.each
    return unless TAP_DIRECTORY.directory?

    TAP_DIRECTORY.subdirs.each do |user|
      user.subdirs.each do |repo|
        yield fetch(user.basename.to_s, repo.basename.to_s)
      end
    end
  end

  # an array of all installed {Tap} names.
  def self.names
    map(&:name)
  end

  # @private
  def formula_file_to_name(file)
    "#{name}/#{file.basename(".rb")}"
  end

  # @private
  def alias_file_to_name(file)
    "#{name}/#{file.basename}"
  end
end
