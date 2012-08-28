require 'formula'

def recursive_deps_tree f, level, sort
  (sort ? f.deps.sort : f.deps).each do |dep|
    puts "> "*level+dep.to_s
    recursive_deps_tree(Formula.factory(dep), level+1, sort)
  end
end

module Homebrew extend self
  def deps
    # Are we dealing with zero, one or many formulae?
    if ARGV.include? '--all' or ARGV.include? '--installed'
      multiple = true
    elsif ARGV.formulae.count > 1
      multiple = true
    elsif ARGV.formulae.count == 1
      multiple = false
    else
      ARGV.push '--all'
      multiple = true
    end

    # Work out the output format
    if ARGV.include? '--tree'
      outputter = lambda { |formula|
        puts formula.name
        recursive_deps_tree(formula, 1, !(ARGV.include? '-n'))
        puts if multiple
      }
    elsif multiple
      outputter = lambda { |formula|
        all_deps = ARGV.one? ? formula.deps : formula.recursive_deps
        all_deps.sort! unless ARGV.include? '-n'
        puts "#{formula.name}: #{all_deps*' '}"
      }
    else
      outputter = lambda { |formula|
        all_deps = ARGV.one? ? formula.deps : formula.recursive_deps
        all_deps.sort! unless ARGV.include? '-n'
        puts all_deps
      }
    end

    # Now select and output the formulae
    if ARGV.include? '--all'
      Formula.each do |f|
        outputter.call(f)
      end
    elsif ARGV.include? '--installed'
      Formula.each do |f|
        if f.installed?
          outputter.call(f)
        end
      end
    else
      ARGV.formulae.each do |f|
        outputter.call(f)
      end
    end
  end
end

class Array
  def intersection
    a = []
    each{ |b| a |= b }
    each{ |c| a &= c }
    a
  end
end
