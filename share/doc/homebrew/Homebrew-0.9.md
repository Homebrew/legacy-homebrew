# Homebrew 0.9
The main new feature in Homebrew-0.9 is `brew tap`.

brew-tap allows you to import formula from other repositories into your Homebrew instance. For example:

    brew tap josegonzalez/php

Will install the recently deleted PHP formula that @josegonzalez maintains because he's the expert and we're not.

We are planning to remove some of the longtail and move it into the new Homebrew organization so that we can keep the formula in mxcl/master in better shape.

`brew search` has been adapted to search over the common taps. So movement of formula will not cause you to not find the formula you are looking for.

Tap has many possibilities; for example, does your organization have its own Homebrew fork with its own custom formula? Well now you can just have a tap and stop having to merge mxcl/master with your own fork all the time.

This also means we will have a dedicated dupes tap so that people can stop asking us to put dupes in mxcl/master. Perhaps you want a formula for every ruby gem? Now you can make a tap!

Formula in mxcl/master cannot be overwritten, so to install a "conflict" you can use an extended syntax, eg:

    brew install homebrew/dupes/gcc42

To untap, use `brew untap`.

Formula can depend on formula from other taps:

    depends_on "homebrew/dupes/tcl-tk"

Though this will not install the tap, it will prompt the user to do that first.
