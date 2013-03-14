require 'formula'

class Formula
  def test_mirror mirror
    # Checksum verification is done against @active_spec, so we need only
    # populate the stub spec object with the mirror URL.
    spec = SoftwareSpec.new(mirror)
    downloader = download_strategy.new(name, spec)

    # Force the downloader to attempt the download by removing the tarball if
    # it is allready cached.
    tarball_path = downloader.tarball_path
    tarball_path.unlink if tarball_path.exist?

    fetched = downloader.fetch
  rescue StandardError
    opoo "Failed to fetch from URL: #{url}"
  else
    verify_download_integrity fetched if fetched.kind_of? Pathname
  end
end

module Homebrew extend self
  def check_mirrors
    mirror_check_usage = <<-EOS
Usage: brew mirror-check <formulae ...>

Cycle through mirror lists for each formula, attempt a download and validate file hashes.
    EOS

    if ARGV.empty?
      puts mirror_check_usage
      exit 0
    end

    formulae = ARGV.formulae
    raise FormulaUnspecifiedError if formulae.empty?

    formulae.each do |f|
      if f.mirrors.empty?
        opoo "#{f.name} has no mirrors"
        next
      else
        oh1 "Testing mirrors for #{f.name}"
        f.mirrors.each{ |m| f.test_mirror m }
      end
    end
  end
end

# Here is the actual code that gets run when `brew` loads this external
# command.
Homebrew.check_mirrors
