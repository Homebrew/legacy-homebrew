require 'formula'

module Homebrew extend self
  def fetch
    raise FormulaUnspecifiedError if ARGV.named.empty?

    if ARGV.include? '--deps'
      bucket = []
      ARGV.formulae.each do |f|
        bucket << f
        bucket.concat f.recursive_dependencies.map(&:to_formula)
      end
      bucket.uniq!
    else
      bucket = ARGV.formulae
    end

    puts "Fetching: #{bucket * ', '}" if bucket.size > 1
    bucket.each { |f| fetch_formula(f) }
  end

  def already_fetched? f
    f.cached_download.exist?
  end

  def fetch_formula f
    f.cached_download.rmtree if already_fetched?(f) && ARGV.force?
    download = f.fetch

    return unless download.file?

    puts "Downloaded to: #{download}" unless already_fetched?(f)
    puts Checksum::TYPES.map { |t| "#{t.to_s.upcase}: #{download.send(t)}" }

    f.verify_download_integrity(download)
  rescue ChecksumMismatchError => e
    Homebrew.failed = true
    opoo "Formula reports different #{e.hash_type}: #{e.expected}"
  end
end
