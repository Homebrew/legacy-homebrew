# brew-allinfo
#
# An external command printing to the terminal the following formula information
# as available:
#
# * Info shown by "brew info ..."
# * Keg-only status & rationale for keg-only formulas
# * Options
#
# Multiple formulas may be given as arguments, and the output is nicely
# formatted.

class Style
  class <<self
    # avoid colors, since we don't know the user's terminal color scheme
    def title; reverse; end
    def head; underline 39; end
    def warn; underline 31; end
    def under; underline 39; end
    def reset; escape 0; end
    
  private
    def reverse
      escape "7"
    end
    def underline n
      escape "4;#{n}"
    end
    def escape n
      "\033[#{n}m" if $stdout.tty?
    end
  end
end

# Adapted from install.rb; if the text is edited, make sure the content is
# consistent with the official message in install.rb.  This version's output
# will be soft-wrapped, so we can be lax with line lengths.  A paragraph
# should be a single-line string (hide line breaks with "\" as needed).
def keg_only_text f
  if f.keg_only? == :provided_by_osx
    rationale = "Mac OS X already provides this resource and installing another version in parallel can cause trouble."
  elsif f.keg_only?.kind_of? String
    rationale = "#{f.keg_only?.chomp}"
  else
    rationale = "The formula does not provide any rationale for this."
  end
  <<-EOS
This formula is keg-only; it is not symlinked into Homebrew's prefix.

#{rationale}

Generally there are no consequences of this for you, however if you build \
your own software and it requires the resource installed by this formula, \
you may want to run the following command to link the resource into the \
Homebrew prefix:

    $ brew link #{f.name}
  EOS
end

num_f = ARGV.formulae.length

ARGV.formulae.each_with_index do |f, i|
  puts "#{Style.title}#{f.name} #{f.version}#{Style.reset}\n\n"
  puts f.homepage

  if f.prefix.parent.directory?
    kids=f.prefix.parent.children
    kids.each do |keg|
      print "Installed in #{keg} (#{keg.abv})"
      print " *" if f.prefix == keg and kids.length > 1
      puts
    end
  else
    puts "Not installed"
  end

  if !f.deps.empty?
    puts "\n#{Style.head}Depends on:#{Style.reset}"
    puts
    # single-line version:
    puts "#{f.deps.join(', ')}" unless f.deps.empty?
    # one-per-line version:
    #f.deps.each do |dep|
    #  print "  ", dep, "\n"
    #end
  else
    puts "No dependencies"
  end

  if f.keg_only?
    print "\n#{Style.head}Keg-only formula:#{Style.reset}\n\n"
    # Wrap text to terminal width.
    print wrap_text(keg_only_text f)
    #print f.keg_only?
  end

  if f.respond_to?('options')
    puts "\n#{Style.head}Options:#{Style.reset}"
    f.options.each do |option|
      puts
      print option[0], "\n"
      # Naive indentation of option text makes long option text in some
      # formulae look horrible; hence the wrapping.
      print wrap_text_in4(option[1])
    end
  end

  if f.caveats
    print "\n#{Style.head}Caveats (this text will be displayed after installation):#{Style.reset}\n\n"
    # Wrap text to 80 col to simplify writing caveats.
    print wrap_text(f.caveats)
  end

  url = github_info(f.name)
  if url
    puts "\n#{Style.head}Formula on GitHub:#{Style.reset}"
    puts
    puts url
  end

  if i < num_f-1  # separator between multiple formulas
    blank_line = " " * $term_width
    puts "#{Style.under}" + blank_line + "#{Style.reset}"  # underlined blanks
  end

end
