require 'formula'

# Downloads the tarballs for the given formulae to the Cache

module Homebrew extend self
  def fetch
    raise FormulaUnspecifiedError if ARGV.named.empty?

    if ARGV.include? '--deps'
      bucket = []
      ARGV.formulae.each do |f|
        bucket << f
        bucket << f.recursive_deps
      end

      bucket = bucket.flatten.uniq
    else
      bucket = ARGV.formulae
    end

    puts "Fetching: #{bucket * ', '}" if bucket.size > 1

    bucket.each do |f|
      already_downloaded = f.cached_download.exist?
      f.cached_download.rmtree if already_downloaded and ARGV.force?

      the_tarball, _ = f.fetch
      next unless the_tarball.kind_of? Pathname

      previous_md5 = f.active_spec.md5.to_s.downcase
      previous_sha1 = f.active_spec.sha1.to_s.downcase
      previous_sha2 = f.active_spec.sha256.to_s.downcase

      puts "Downloaded to: #{the_tarball}" unless already_downloaded
      puts "MD5:  #{the_tarball.md5}"
      puts "SHA1: #{the_tarball.sha1}"
      puts "SHA256: #{the_tarball.sha2}"

      begin
        f.verify_download_integrity the_tarball
      rescue ChecksumMismatchError => e
        opoo "Formula reports different #{e.hash_type}: #{e.expected}"
      end
    end
  end
end
