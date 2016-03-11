# Gets a patch from a GitHub commit or pull request and applies it to Homebrew.
# Optionally, installs the formulae changed by the patch.
#
# Usage: brew pull [options...] <patch-source>
#
# <patch-source> may be any of:
#   * The ID number of a pull request in the Homebrew GitHub repo
#   * The URL of a pull request on GitHub, using either the web page or API URL formats
#   * The URL of a commit on GitHub
#   * A "brew.sh/job/..." string specifying a testing job ID
#
# Options:
#   --bottle:    Handle bottles, pulling the bottle-update commit and publishing files on Bintray
#   --bump:      For one-formula PRs, automatically reword commit message to our preferred format
#   --clean:     Do not rewrite or otherwise modify the commits found in the pulled PR
#   --ignore-whitespace: Silently ignore whitespace discrepancies when applying diffs
#   --install:   Install changed formulae locally after pulling the patch
#   --resolve:   When a patch fails to apply, leave in progress and allow user to
#                 resolve, instead of aborting
#   --branch-okay: Do not warn if pulling to a branch besides master (useful for testing)

require "utils"
require "utils/json"
require "formula"
require "tap"

module Homebrew
  def pull
    if ARGV[0] == "--rebase"
      odie "You meant `git pull --rebase`."
    end
    if ARGV.named.empty?
      odie "This command requires at least one argument containing a URL or pull request number"
    end
    do_bump = ARGV.include?("--bump") && !ARGV.include?("--clean")

    bintray_fetch_formulae = []

    ARGV.named.each do |arg|
      if arg.to_i > 0
        issue = arg
        url = "https://github.com/Homebrew/homebrew/pull/#{arg}"
        tap = CoreTap.instance
      elsif (testing_match = arg.match %r{brew.sh/job/Homebrew.*Testing/(\d+)/})
        _, testing_job = *testing_match
        url = "https://github.com/Homebrew/homebrew/compare/master...BrewTestBot:testing-#{testing_job}"
        tap = CoreTap.instance
        odie "Testing URLs require `--bottle`!" unless ARGV.include?("--bottle")
      elsif (api_match = arg.match HOMEBREW_PULL_API_REGEX)
        _, user, repo, issue = *api_match
        url = "https://github.com/#{user}/homebrew#{repo}/pull/#{issue}"
        tap = Tap.fetch(user, "homebrew#{repo}")
      elsif (url_match = arg.match HOMEBREW_PULL_OR_COMMIT_URL_REGEX)
        url, user, repo, issue = *url_match
        tap = Tap.fetch(user, "homebrew#{repo}")
      else
        odie "Not a GitHub pull request or commit: #{arg}"
      end

      if !testing_job && ARGV.include?("--bottle") && issue.nil?
        raise "No pull request detected!"
      end

      tap.install unless tap.installed?
      Dir.chdir tap.path

      # The cache directory seems like a good place to put patches.
      HOMEBREW_CACHE.mkpath

      # Store current revision and branch
      revision = `git rev-parse --short HEAD`.strip
      branch = `git symbolic-ref --short HEAD`.strip

      unless branch == "master" || ARGV.include?("--clean") || ARGV.include?("--branch-okay")
        opoo "Current branch is #{branch}: do you need to pull inside master?"
      end

      patch_puller = PatchPuller.new(url)
      patch_puller.fetch_patch
      patch_changes = files_changed_in_patch(patch_puller.patchpath, tap)
      is_bumpable = patch_changes[:formulae].length == 1 && patch_changes[:others].empty?
      if do_bump
        odie "No changed formulae found to bump" if patch_changes[:formulae].empty?
        if patch_changes[:formulae].length > 1
          odie "Can only bump one changed formula; bumped #{patch_changes[:formulae]}"
        end
        odie "Can not bump if non-formula files are changed" unless patch_changes[:others].empty?
      end
      if is_bumpable
        old_versions = current_versions_from_info_external(patch_changes[:formulae].first)
      end
      patch_puller.apply_patch

      changed_formulae = []

      Utils.popen_read(
        "git", "diff-tree", "-r", "--name-only",
        "--diff-filter=AM", revision, "HEAD", "--", tap.formula_dir.to_s
      ).each_line do |line|
        name = "#{tap.name}/#{File.basename(line.chomp, ".rb")}"
        begin
          changed_formulae << Formula[name]
        # Make sure we catch syntax errors.
        rescue Exception
          next
        end
      end

      fetch_bottles = false
      changed_formulae.each do |f|
        if ARGV.include? "--bottle"
          if f.bottle_unneeded?
            ohai "#{f}: skipping unneeded bottle."
          elsif f.bottle_disabled?
            ohai "#{f}: skipping disabled bottle: #{f.bottle_disable_reason}"
          else
            fetch_bottles = true
          end
        else
          next unless f.bottle_defined?
          opoo "#{f.full_name} has a bottle: do you need to update it with --bottle?"
        end
      end

      orig_message = message = `git log HEAD^.. --format=%B`
      if issue && !ARGV.include?("--clean")
        ohai "Patch closes issue ##{issue}"
        # If this is a pull request, append a close message.
        unless message.include? "Closes ##{issue}."
          message += "\nCloses ##{issue}."
        end
      end

      if changed_formulae.empty?
        odie "cannot bump: no changed formulae found after applying patch" if do_bump
        is_bumpable = false
      end
      if is_bumpable && !ARGV.include?("--clean")
        formula = changed_formulae.first
        new_versions = {
          :stable => formula.stable.nil? ? nil : formula.stable.version.to_s,
          :devel => formula.devel.nil? ? nil : formula.devel.version.to_s,
        }
        orig_subject = message.empty? ? "" : message.lines.first.chomp
        subject = subject_for_bump(formula, old_versions, new_versions)
        if do_bump
          odie "No version changes found for #{formula.name}" if subject.nil?
          unless orig_subject == subject
            ohai "New bump commit subject: #{subject}"
            pbcopy subject
            message = "#{subject}\n\n#{message}"
          end
        elsif subject != orig_subject && !subject.nil?
          opoo "Nonstandard bump subject: #{orig_subject}"
          opoo "Subject should be: #{subject}"
        end
      end

      if message != orig_message && !ARGV.include?("--clean")
        safe_system "git", "commit", "--amend", "--signoff", "--allow-empty", "-q", "-m", message
      end

      if fetch_bottles
        bottle_commit_url = if testing_job
          bottle_branch = "testing-bottle-#{testing_job}"
          url
        else
          bottle_branch = "pull-bottle-#{issue}"
          if tap.core_tap?
            "https://github.com/BrewTestBot/homebrew/compare/homebrew:master...pr-#{issue}"
          else
            "https://github.com/BrewTestBot/homebrew-#{tap.repo}/compare/homebrew:master...pr-#{issue}"
          end
        end
        curl "--silent", "--fail", "-o", "/dev/null", "-I", bottle_commit_url

        safe_system "git", "checkout", "-B", bottle_branch, revision
        pull_patch bottle_commit_url
        safe_system "git", "rebase", branch
        safe_system "git", "checkout", branch
        safe_system "git", "merge", "--ff-only", "--no-edit", bottle_branch
        safe_system "git", "branch", "-D", bottle_branch

        # Publish bottles on Bintray
        bintray_user = ENV["BINTRAY_USER"]
        bintray_key = ENV["BINTRAY_KEY"]

        if bintray_user && bintray_key
          repo = Bintray.repository(tap)
          changed_formulae.each do |f|
            next if f.bottle_unneeded? || f.bottle_disabled?
            ohai "Publishing on Bintray:"
            package = Bintray.package f.name
            version = f.pkg_version
            curl "-w", '\n', "--silent", "--fail",
              "-u#{bintray_user}:#{bintray_key}", "-X", "POST",
              "-H", "Content-Type: application/json",
              "-d", '{"publish_wait_for_secs": 0}',
              "https://api.bintray.com/content/homebrew/#{repo}/#{package}/#{version}/publish"
            bintray_fetch_formulae << f
          end
        else
          opoo "You must set BINTRAY_USER and BINTRAY_KEY to add or update bottles on Bintray!"
        end
      end

      ohai "Patch changed:"
      safe_system "git", "diff-tree", "-r", "--stat", revision, "HEAD"

      if ARGV.include? "--install"
        changed_formulae.each do |f|
          ohai "Installing #{f.full_name}"
          install = f.installed? ? "upgrade" : "install"
          safe_system "brew", install, "--debug", f.full_name
        end
      end
    end

    bintray_fetch_formulae.each do |f|
      max_retries = 8
      retry_count = 0
      begin
        success = system "brew", "fetch", "--force-bottle", f.full_name
        raise "Failed to download #{f} bottle!" unless success
      rescue RuntimeError => e
        retry_count += 1
        raise e if retry_count >= max_retries
        sleep_seconds = 2**retry_count
        ohai "That didn't work; sleeping #{sleep_seconds} seconds and trying again..."
        sleep sleep_seconds
        retry
      end
    end
  end

  private

  def pull_patch(url)
    PatchPuller.new(url).pull_patch
  end

  class PatchPuller
    attr_reader :base_url
    attr_reader :patch_url
    attr_reader :patchpath

    def initialize(url)
      @base_url = url
      # GitHub provides commits/pull-requests raw patches using this URL.
      @patch_url = url + ".patch"
      @patchpath = HOMEBREW_CACHE + File.basename(patch_url)
    end

    def pull_patch
      fetch_patch
      apply_patch
    end

    def fetch_patch
      ohai "Fetching patch"
      curl patch_url, "-o", patchpath
    end

    def apply_patch
      # Applies a patch previously downloaded with fetch_patch()
      # Deletes the patch file as a side effect, regardless of success

      ohai "Applying patch"
      patch_args = []
      # Normally we don't want whitespace errors, but squashing them can break
      # patches so an option is provided to skip this step.
      if ARGV.include?("--ignore-whitespace") || ARGV.include?("--clean")
        patch_args << "--whitespace=nowarn"
      else
        patch_args << "--whitespace=fix"
      end

      # Fall back to three-way merge if patch does not apply cleanly
      patch_args << "-3"
      patch_args << patchpath

      begin
        safe_system "git", "am", *patch_args
      rescue ErrorDuringExecution
        if ARGV.include? "--resolve"
          odie "Patch failed to apply: try to resolve it."
        else
          system "git", "am", "--abort"
          odie "Patch failed to apply: aborted."
        end
      ensure
        patchpath.unlink
      end
    end
  end

  # List files changed by a patch, partitioned in to those that are (probably)
  # formula definitions, and those which aren't. Only applies to patches on
  # Homebrew core or taps, based simply on relative pathnames of affected files.
  def files_changed_in_patch(patchfile, tap)
    files = []
    formulae = []
    others = []
    File.foreach(patchfile) do |line|
      files << $1 if line =~ %r{^\+\+\+ b/(.*)}
    end
    files.each do |file|
      if tap.formula_file?(file)
        formula_name = File.basename(file, ".rb")
        formulae << formula_name unless formulae.include?(formula_name)
      else
        others << file
      end
    end
    { :files => files, :formulae => formulae, :others => others }
  end

  # Get current formula versions without loading formula definition in this process
  # Returns info as a hash (type => version), for pull.rb's internal use
  # Uses special key :nonexistent => true for nonexistent formulae
  def current_versions_from_info_external(formula_name)
    versions = {}
    json = Utils.popen_read(HOMEBREW_BREW_FILE, "info", "--json=v1", formula_name)
    if $?.success?
      info = Utils::JSON.load(json)
      [:stable, :devel, :head].each do |vertype|
        versions[vertype] = info[0]["versions"][vertype.to_s]
      end
    else
      versions[:nonexistent] = true
    end
    versions
  end

  def subject_for_bump(formula, old, new)
    if old[:nonexistent]
      # New formula
      headline_ver = new[:stable] ? new[:stable] : new[:devel] ? new[:devel] : new[:head]
      subject = "#{formula.name} #{headline_ver} (new formula)"
    else
      # Update to existing formula
      subject_strs = []
      formula_name_str = formula.name
      if old[:stable] != new[:stable]
        if new[:stable].nil?
          subject_strs << "remove stable"
          formula_name_str += ":" # just for cosmetics
        else
          subject_strs << formula.version.to_s
        end
      end
      if old[:devel] != new[:devel]
        if new[:devel].nil?
          # Only bother mentioning if there's no accompanying stable change
          if !new[:stable].nil? && old[:stable] == new[:stable]
            subject_strs << "remove devel"
            formula_name_str += ":" # just for cosmetics
          end
        else
          subject_strs << "#{formula.devel.version} (devel)"
        end
      end
      subject = subject_strs.empty? ? nil : "#{formula_name_str} #{subject_strs.join(", ")}"
    end
    subject
  end

  def pbcopy(text)
    Utils.popen_write("pbcopy") { |io| io.write text }
  end
end
