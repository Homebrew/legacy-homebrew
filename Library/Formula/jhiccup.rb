require "formula"

class Jhiccup < Formula
  homepage "http://www.jhiccup.com"
  url "http://www.azulsystems.com/sites/default/files/images/jHiccup.1.3.7.zip"
  sha1 "2bd5ad585b50b80b6a12d6b2d5338fde8c18a10b"

  # Simple script to create and open a new plotter spreadsheet
  def script; %Q(#!/bin/sh
TMPFILE="/tmp/jHiccupPlotter.$$.xls"
cp "#{prefix}/jHiccupPlotter.xls" $TMPFILE
open $TMPFILE)
  end

  def install
    bin.install "jHiccup"
    (bin+'jHiccupPlotter').write script
    prefix.install "target"
    prefix.install "jHiccupPlotter.xls"
    inreplace "#{bin}/jHiccup" do |s|
      s.gsub! /^JHICCUP_JAR_FILE=.*$/,
              "JHICCUP_JAR_FILE=#{prefix}/target/jHiccup.jar"
    end
  end
end
