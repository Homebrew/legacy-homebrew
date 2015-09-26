require "utils/json"

# a {Tap} is used to extend the formulae provided by Homebrew core.
# Usually, it's synced with a remote git repository. And it's likely
# a Github repository with the name of `user/homebrew-repo`. In such
# case, `user/repo` will be used as the {#name} of this {Tap}, where
# {#user} represents Github username and {#repo} represents repository
# name without leading `homebrew-`.
class Tap
  TAP_DIRECTORY = HOMEBREW_LIBRARY/"Taps"

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

  def initialize(user, repo)
    # we special case homebrew so users don't have to shift in a terminal
    @user = user == "homebrew" ? "Homebrew" : user
    @repo = repo
    @name = "#{@user}/#{@repo}".downcase
    @path = TAP_DIRECTORY/"#{@user}/homebrew-#{@repo}".downcase
  end

  # The remote path to this {Tap}.
  # e.g. `https://github.com/user/homebrew-repo`
  def remote
    @remote ||= if installed?
      if git?
        @path.cd do
          Utils.popen_read("git", "config", "--get", "remote.origin.url").chomp
        end
      end
    else
      raise TapUnavailableError, name
    end
  end

  # True if this {Tap} is a git repository.
  def git?
    (@path/".git").exist?
  end

  def to_s
    name
  end

  # True if this {Tap} is an official Homebrew tap.
  def official?
    @user == "Homebrew"
  end

  # True if the remote of this {Tap} is a private repository.
  def private?
    return true if custom_remote?
    GitHub.private_repo?(@user, "homebrew-#{@repo}")
  rescue GitHub::HTTPNotFoundError
    true
  rescue GitHub::Error
    false
  end

  # True if this {Tap} has been installed.
  def installed?
    @path.directory?
  end

  # True if the {#remote} of {Tap} is customized.
  def custom_remote?
    return true unless remote
    remote.casecmp("https://github.com/#{@user}/homebrew-#{@repo}") != 0
  end

  # an array of all {Formula} files of this {Tap}.
  def formula_files
    dir = [@path/"Formula", @path/"HomebrewFormula", @path].detect(&:directory?)
    return [] unless dir
    dir.children.select { |p| p.extname == ".rb" }
  end

  # an array of all {Formula} names of this {Tap}.
  def formula_names
    formula_files.map { |f| "#{name}/#{f.basename(".rb")}" }
  end

  # an array of all alias files of this {Tap}.
  # @private
  def alias_files
    Pathname.glob("#{path}/Aliases/*").select(&:file?)
  end

  # an array of all aliases of this {Tap}.
  # @private
  def aliases
    alias_files.map { |f| "#{name}/#{f.basename}" }
  end

  # an array of all commands files of this {Tap}.
  def command_files
    Pathname.glob("#{path}/cmd/brew-*").select(&:executable?)
  end

  def pinned_symlink_path
    HOMEBREW_LIBRARY/"PinnedTaps/#{@name}"
  end

  def pinned?
    @pinned ||= pinned_symlink_path.directory?
  end

  def pin
    raise TapUnavailableError, name unless installed?
    raise TapPinStatusError.new(name, true) if pinned?
    pinned_symlink_path.make_relative_symlink(@path)
  end

  def unpin
    raise TapUnavailableError, name unless installed?
    raise TapPinStatusError.new(name, false) unless pinned?
    pinned_symlink_path.delete
    pinned_symlink_path.dirname.rmdir_if_possible
  end

  def to_hash
    hash = {
      "name" => @name,
      "user" => @user,
      "repo" => @repo,
      "path" => @path.to_s,
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
    @formula_renames ||= if (rename_file = path/"formula_renames.json").file?
      Utils::JSON.load(rename_file.read)
    else
      {}
    end
  end

  def self.each
    return unless TAP_DIRECTORY.directory?

    TAP_DIRECTORY.subdirs.each do |user|
      user.subdirs.each do |repo|
        yield new(user.basename.to_s, repo.basename.to_s.sub("homebrew-", ""))
      end
    end
  end

  # an array of all installed {Tap} names.
  def self.names
    map(&:name)
  end
end
