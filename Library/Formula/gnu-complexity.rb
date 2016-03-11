class GnuComplexity < Formula
  desc "Measures complexity of C source"
  homepage "https://www.gnu.org/software/complexity"
  url "http://ftpmirror.gnu.org/complexity/complexity-1.5.tar.xz"
  mirror "https://ftp.gnu.org/gnu/complexity/complexity-1.5.tar.xz"
  sha256 "1f5194c0dc6e813ea1dc7f36bfd05f15786a8ad6e9b3ab65b53d2263a0d93102"

  bottle do
    cellar :any
    sha256 "544d5ebed4cc5f67c8163c235b3395b037b7a3f1ca65a7a9b7933fd0a720372d" => :el_capitan
    sha256 "8ea7c8980ece29c92bbd61fb0c407d636bbb92f648b2766be2d6b729fdc496f9" => :yosemite
    sha256 "fe927c4a8849726433828cec20ac0716a543105f2038e030cdf4e4df2085adc0" => :mavericks
  end

  depends_on "autogen" => :run

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      void free_table(uint32_t *page_dir) {
          // The last entry of the page directory is reserved. It points to the page
          // table itself.
          for (size_t i = 0; i < PAGE_TABLE_SIZE-2; ++i) {
              uint32_t *page_entry = (uint32_t*)GETADDRESS(page_dir[i]);
              for (size_t j = 0; j < PAGE_TABLE_SIZE; ++j) {
                  uintptr_t addr = (i<<20|j<<12);
                  if (addr == VIDEO_MEMORY_BEGIN ||
                          (addr >= KERNEL_START && addr < KERNEL_END)) {
                      continue;
                  }
                  if ((page_entry[j] & PAGE_PRESENT) == 1) {
                      free_frame(page_entry[j]);
                  }
              }
          }
          free_frame((page_frame_t)page_dir);
      }
    EOS
    system bin/"complexity", "-t", "3", "./test.c"
  end
end
