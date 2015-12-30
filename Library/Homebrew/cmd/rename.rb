require "formula"

module Homebrew
  # TODO change to mv?
  def rename
    # TODO add come alert like brew edit has

    # Don't use ARGV.formulae as that will throw if the file doesn't parse
    raise "There should be exactly two arguments passed" if ARGV.named.size != 2

    # TODO add some check here
    from = Formulary.path(ARGV.named.first)
    to = from.parent.join("#{ARGV.named.last}.rb")
    from.rename(to)

    File.open("#{HOMEBREW_LIBRARY}/Homebrew/Renames/#{ARGV.named.first}", "a+") do |file|
      file.write("#{ARGV.named.last}, #{get_master_commit}")
    end

    # TODO move to the right place or remove
    exec_editor(to)
  end

  def get_master_commit
    Utils.popen_read("git", "rev-parse", "origin/master")
  end
end
