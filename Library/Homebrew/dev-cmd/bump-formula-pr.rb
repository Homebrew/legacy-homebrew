# Creates a pull request with the new version of a formula.
#
# Usage: brew bump [options...] <formula-name>
#
# Requires either `--url` and `--sha256` or `--tag` and `--revision`.
#
# Options:
#   --dry-run:  Print what would be done rather than doing it.
#   --devel:    Bump a `devel` rather than `stable` version.
#   --url:      The new formula URL.
#   --sha256:   The new formula SHA-256.
#   --tag:      The new formula's `tag`
#   --revision: The new formula's `revision`.

require "formula"

module Homebrew
  def bump_formula_pr
    formula = ARGV.formulae.first
    odie "No formula found!" unless formula

    requested_spec, formula_spec = if ARGV.include?("--devel")
      devel_message = " (devel)"
      [:devel, formula.devel]
    else
      [:stable, formula.stable]
    end
    odie "#{formula}: no #{requested_spec} specification found!" unless formula_spec

    hash_type, old_hash = if (checksum = formula_spec.checksum)
      [checksum.hash_type.to_s, checksum.hexdigest]
    end

    new_url = ARGV.value("url")
    new_hash = ARGV.value(hash_type)
    new_tag = ARGV.value("tag")
    new_revision = ARGV.value("revision")
    new_url_hash = if new_url && new_hash
      true
    elsif new_tag && new_revision
      false
    elsif !hash_type
      odie "#{formula}: no tag/revision specified!"
    else
      odie "#{formula}: no url/#{hash_type} specified!"
    end

    if ARGV.dry_run?
      ohai "brew update"
    else
      safe_system "brew", "update"
    end

    Utils::Inreplace.inreplace(formula.path) do |s|
      if new_url_hash
        old_url = formula_spec.url
        if ARGV.dry_run?
          ohai "replace '#{old_url}' with '#{new_url}'"
          ohai "replace '#{old_hash}' with '#{new_hash}'"
        else
          s.gsub!(old_url, new_url)
          s.gsub!(old_hash, new_hash)
        end
      else
        resource_specs = formula_spec.specs
        old_tag = resource_specs[:tag]
        old_revision = resource_specs[:revision]
        if ARGV.dry_run?
          ohai "replace '#{old_tag}' with '#{new_tag}'"
          ohai "replace '#{old_revision}' with '#{new_revision}'"
        else
          s.gsub!(/['"]#{old_tag}['"]/, "\"#{new_tag}\"")
          s.gsub!(old_revision, new_revision)
        end
      end
    end

    new_formula = Formulary.load_formula_from_path(formula.name, formula.path)
    new_formula_version = new_formula.version

    unless Formula["hub"].any_version_installed?
      if ARGV.dry_run?
        ohai "brew install hub"
      else
        safe_system "brew", "install", "hub"
      end
    end

    formula.path.parent.cd do
      branch = "#{formula.name}-#{new_formula_version}"
      if ARGV.dry_run?
        ohai "git checkout -b #{branch} origin/master"
        ohai "git commit --no-edit --verbose --message='#{formula.name} #{new_formula_version}#{devel_message}' -- #{formula.path}"
        ohai "hub fork --no-remote"
        ohai "hub fork"
        ohai "hub fork (to read $HUB_REMOTE)"
        ohai "git push $HUB_REMOTE #{branch}:#{branch}"
        ohai "hub pull-request --browse -m '#{formula.name} #{new_formula_version}#{devel_message}'"
      else
        safe_system "git", "checkout", "-b", branch, "origin/master"
        safe_system "git", "commit", "--no-edit", "--verbose",
          "--message=#{formula.name} #{new_formula_version}#{devel_message}",
          "--", formula.path
        safe_system "hub", "fork", "--no-remote"
        quiet_system "hub", "fork"
        remote = Utils.popen_read("hub fork 2>&1")[/fatal: remote (.+) already exists./, 1]
        odie "cannot get remote from 'hub'!" if remote.to_s.empty?
        safe_system "git", "push", remote, "#{branch}:#{branch}"
        safe_system "hub", "pull-request", "--browse", "-m",
          "#{formula.name} #{new_formula_version}#{devel_message}\n\nCreated with `brew bump-formula-pr`."
      end
    end
  end
end
