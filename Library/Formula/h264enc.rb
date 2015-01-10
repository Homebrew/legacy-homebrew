class H264enc < Formula
  homepage "http://h264enc.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/h264enc/h264enc/h264enc-9.9.0.tar.gz"
  sha1 "8bfa7017386a4b7612acd21e48dedf940652582d"

   # mplayer needs x264 installed first 
  depends_on "x264"
  depends_on "mplayer"
  depends_on "lsdvd"
  depends_on "libbluray"
  depends_on "flac"
  depends_on "faac"
  depends_on "lame"
  depends_on "mkvtoolnix"
  # >= 0.4.5
  depends_on "gpac"
  depends_on "ogmtools"
  depends_on "vorbis-tools"
  
  def install

    # Test mencoder, is there a better way?
    ohai "Checking 'MEncoder' for x264 encoding"
    begin
	system "test ! -z \"$(mencoder -ovc help 2>/dev/null | awk '{print $1}' | grep 'x264')\""
    rescue BuildError
    	onoe "MEncoder wasn't built with x264. Uninstall 'brew uninstall mplayer' then reinstall 'brew install x264 mplayer'"
	raise
    end

    bin.mkpath
    man.mkpath
    doc.mkpath

    # fix the termcap issues using tput instead (could replace \e with \x1B or \033
    inreplace "h264enc" do |s|
      # Reset text format to the terminal's default
      s.gsub! /\\e\[0;39;49m/, "$(tput sgr 0)"
      s.gsub! /\\e\[0;0m/, "$(tput sgr 0)"
      # Brown/Yellow
      s.gsub! /\\e\[0;33m/, "$(tput setaf 3)"
      # Green (default)
      s.gsub! /\\e\[1;32m/, "$(tput setaf 2)"
      # Bold and red
      s.gsub! /\\e\[1;31m/, "$(tput bold)$(tput setaf 1)"
      # Blue (printf not echo)
      # s.gsub! /\\033\[01;34m/, "$(tput setaf 4)"

    end

    # manual copy stuff (this is what the install does, but as root)
    # "#{prefix}"
    bin.install "h264enc"

    # mapages go to "#{man}" --> [prefix]/share/man
    man.install "man/h264enc.1"
    
    # docs
    # base install expects /usr/local/share/doc/h264enc
    # 
    doc.install Dir["doc/*"]

    # matrix files
    # base install expects /usr/local/share/doc/h264enc/matrices
    system "mkdir -p -m 755 #{doc}/matrices && cp -f matrices/* #{doc}/matrices && chmod 644 #{doc}/matrices/*"
    
  end

  test do
    system "false"
  end
end
