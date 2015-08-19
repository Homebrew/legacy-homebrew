class Ford < Formula
  desc "Automatic documentation generator for modern Fortran programs"
  homepage "https://github.com/cmacmackin/ford/"
  url "https://pypi.python.org/packages/source/F/FORD/FORD-4.1.0.tar.gz"
  sha256 "ec04b08468f75ac0acbda4fd6a15a432eb267e9c28098b5937125a95d2c6fdff"

  head "https://github.com/cmacmackin/ford.git"

  bottle do
    cellar :any
    sha256 "b69f60eaef6d9f2ce43a8a17ad6e96fdc14b5a44508ce7c35e9ce083334a46b6" => :yosemite
    sha256 "9b16cc8ab21faa866d70a954f8b54d9824f6cc09fcfa9a99659d38d4e3824eea" => :mavericks
    sha256 "c149f7b6422be7355dac922c4ed691716e8c5eb0258af294777fefff308af615" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "toposort" do
    url "https://pypi.python.org/packages/source/t/toposort/toposort-1.4.tar.gz"
    sha256 "c190b9d9a9e53ae2835f4d524130147af601fbd63677d19381c65067a80fa903"
  end

  resource "Markdown" do
    url "https://pypi.python.org/packages/source/M/Markdown/Markdown-2.6.2.tar.gz"
    sha256 "ee17d0d7dc091e645dd48302a2e21301cc68f188505c2069d8635f94554170bf"
  end

  resource "beautifulsoup4" do
    url "https://pypi.python.org/packages/source/b/beautifulsoup4/beautifulsoup4-4.4.0.tar.gz"
    sha256 "fad91da88f69438b9ba939ab1b2cabaa31b1d914f1cccb4bb157a993ed2917f6"
  end

  resource "markdown-include" do
    url "https://pypi.python.org/packages/source/m/markdown-include/markdown-include-0.5.1.tar.gz"
    sha256 "72a45461b589489a088753893bc95c5fa5909936186485f4ed55caa57d10250f"
  end

  resource "MarkupSafe" do
    url "https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  resource "Jinja2" do
    url "https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.8.tar.gz"
    sha256 "bc1ff2ff88dbfacefde4ddde471d1417d3b304e8df103a7a9437d47269201bf4"
  end

  resource "Pygments" do
    url "https://pypi.python.org/packages/source/P/Pygments/Pygments-2.0.2.tar.gz"
    sha256 "7320919084e6dac8f4540638a46447a3bd730fca172afc17d2c03eed22cf4f51"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[toposort Markdown beautifulsoup4 markdown-include MarkupSafe Jinja2 Pygments].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    (testpath/"test-project.md").write <<-EOS.undent
      project_dir: ./src
      output_dir: ./doc
      project_github: https://github.com/cmacmackin/futility
      project_website: http://github.com
      summary: Some Fortran program which I wrote.
      author: John Doe
      author_description: I program stuff in Fortran.
      github: https://github.com/cmacmackin
      email: john.doe@address.com
      predocmark: >
      docmark_alt: #
      predocmark_alt: <
      macro: TEST
             LOGIC=.true.

      This is a project which I wrote. This file will provide the documents. I'm
      writing the body of the text here. It contains an overall description of the
      project. It might explain how to go about installing/compiling it. It might
      provide a change-log for the code. Maybe it will talk about the history and/or
      motivation for this software.

      @Note
      You can include any notes (or bugs, warnings, or todos) like so.

      You can have as many paragraphs as you like here and can use headlines, links,
      images, etc. Basically, you can use anything in Markdown and Markdown-Extra.
      Furthermore, you can insert LaTeX into your documentation. So, for example,
      you can provide inline math using like \( y = x^2 \) or math on its own line
      like \[ x = \sqrt{y} \] or $$ e = mc^2. $$ You can even use LaTeX environments!
      So you can get numbered equations like this:
      \begin{equation}
        PV = nRT
      \end{equation}
      So let your imagination run wild. As you can tell, I'm more or less just
      filling in space now. This will be the last sentence.
    EOS
    mkdir testpath/"src" do
      (testpath/"src"/"ford_test_program.f90").write <<-EOS.undent
        program ford_test_program
          !! Simple Fortran program to demonstrate the usage of FORD and to test its installation
          use iso_fortran_env, only: output_unit, real64
          implicit none
          real (real64) :: global_pi = acos(-1)
          !! a global variable, initialized to the value of pi

          write(output_unit,'(A)') 'Small test program'
          call do_stuff(20)

        contains
          subroutine do_stuff(repeat)
            !! This is documentation for our subroutine that does stuff and things.
            !! This text is captured by ford
            integer, intent(in) :: repeat
            !! The number of times to repeatedly do stuff and things
            integer :: i
            !! internal loop counter

            ! the main content goes here and this is comment is not processed by FORD
            do i=1,repeat
               global_pi = acos(-1)
            end do
          end subroutine
        end program
      EOS
    end
    system "#{bin}/ford", testpath/"test-project.md"
    assert File.exist?(testpath/"doc"/"index.html")
  end
end
