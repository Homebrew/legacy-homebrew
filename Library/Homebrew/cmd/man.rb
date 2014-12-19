require 'formula'

module Homebrew
  SOURCE_PATH=HOMEBREW_REPOSITORY/"Library/Homebrew/manpages"
  TARGET_PATH=HOMEBREW_REPOSITORY/"share/man/man1"
  LINKED_PATH=HOMEBREW_PREFIX/"share/man/man1"

  def man
    if ARGV.include?("--link") || ARGV.include?("-l")
      Dir["#{TARGET_PATH}/*.1"].each do |page|
        FileUtils.ln_s page, LINKED_PATH
        return
      end
    end

    which("ronn") || odie("You need to \"gem install ronn\" and put it in your path.")

    if ARGV.include?("--server") || ARGV.include?("-s")
      puts "Man page test server: http://localhost:1207/"
      puts "Control-C to exit."
      system "ronn", "--server", Dir["#{SOURCE_PATH}/*"]
      return
    end

    puts "Writing manpages to #{TARGET_PATH}"

    target_file = nil
    Dir["#{SOURCE_PATH}/*.md"].each do |source_file|
      target_file = TARGET_PATH/File.basename(source_file, ".md")
      safe_system "ronn --roff --pipe --organization='Homebrew' --manual='brew' #{source_file} > #{target_file}"
    end

    if ARGV.include?("--verbose") || ARGV.include?("-v")
      system "man", target_file
    end
  end
end
