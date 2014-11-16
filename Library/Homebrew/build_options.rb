class BuildOptions
  def initialize(args, options)
    @args = args
    @options = options
  end

  def include? name
    @args.include?("--#{name}")
  end

  def with? val
    name = val.respond_to?(:option_name) ? val.option_name : val

    if option_defined? "with-#{name}"
      include? "with-#{name}"
    elsif option_defined? "without-#{name}"
      not include? "without-#{name}"
    else
      false
    end
  end

  def without? name
    not with? name
  end

  def bottle?
    include? "build-bottle"
  end

  def head?
    include? "HEAD"
  end

  def devel?
    include? "devel"
  end

  def stable?
    not (head? or devel?)
  end

  # True if the user requested a universal build.
  def universal?
    include?("universal") && option_defined?("universal")
  end

  # True if the user requested to enable C++11 mode.
  def cxx11?
    include?("c++11") && option_defined?("c++11")
  end

  # Request a 32-bit only build.
  # This is needed for some use-cases though we prefer to build Universal
  # when a 32-bit version is needed.
  def build_32_bit?
    include?("32-bit") && option_defined?("32-bit")
  end

  def used_options
    @options & @args
  end

  def unused_options
    @options - @args
  end

  private

  def option_defined? name
    @options.include? name
  end
end
