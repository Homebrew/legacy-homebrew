# Gets a patch from a GitHub commit or pull request and applies it to Homebrew.
# Optionally, installs it too.

require "utils"
require "formula"
require "tap"
require "core_formula_repository"

module Homebrew
  def pull_url(url)
    # GitHub provides commits/pull-requests raw patches using this URL.
    url += ".patch"

    patchpath = HOMEBREW_CACHE + File.basename(url)
    curl url, "-o", patchpath

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

  def pull
    if ARGV.empty?
      odie "This command requires at least one argument containing a URL or pull request number"
    end

    if ARGV[0] == "--rebase"
      odie "You meant `git pull --rebase`."
    end

    bintray_fetch_formulae =[]

    ARGV.named.each do |arg|
      if arg.to_i > 0
        issue = arg
        url = "https://github.com/Homebrew/homebrew/pull/#{arg}"
        tap = CoreFormulaRepository.instance
      elsif (testing_match = arg.match %r{brew.sh/job/Homebrew.*Testing/(\d+)/})
        _, testing_job = *testing_match
        url = "https://github.com/Homebrew/homebrew/compare/master...BrewTestBot:testing-#{testing_job}"
        tap = CoreFormulaRepository.instance
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

      unless branch == "master"
        opoo "Current branch is #{branch}: do you need to pull inside master?" unless ARGV.include? "--clean"
      end

      pull_url url

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

      if issue && !ARGV.include?("--clean")
        ohai "Patch closes issue ##{issue}"
        message = `git log HEAD^.. --format=%B`

        if ARGV.include? "--bump"
          odie "Can only bump one changed formula" unless changed_formulae.length == 1
          formula = changed_formulae.first
          subject = "#{formula.name} #{formula.version}"
          ohai "New bump commit subject: #{subject}"
          system "/bin/echo -n #{subject} | pbcopy"
          message = "#{subject}\n\n#{message}"
        end

        # If this is a pull request, append a close message.
        unless message.include? "Closes ##{issue}."
          message += "\nCloses ##{issue}."
          safe_system "git", "commit", "--amend", "--signoff", "--allow-empty", "-q", "-m", message
        end
      end

      if fetch_bottles
        bottle_commit_url = if testing_job
          bottle_branch = "testing-bottle-#{testing_job}"
          url
        else
          bottle_branch = "pull-bottle-#{issue}"
          if tap.core_formula_repository?
            "https://github.com/BrewTestBot/homebrew/compare/homebrew:master...pr-#{issue}"
          else
            "https://github.com/BrewTestBot/homebrew-#{tap.repo}/compare/homebrew:master...pr-#{issue}"
          end
        end
        curl "--silent", "--fail", "-o", "/dev/null", "-I", bottle_commit_url

        safe_system "git", "checkout", "-B", bottle_branch, revision
        pull_url bottle_commit_url
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
              "-d", '{"publish_wait_for_secs": -1}',
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
end
