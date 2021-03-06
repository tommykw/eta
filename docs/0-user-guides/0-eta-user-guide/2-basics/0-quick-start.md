# Quick Start

## Overview

If you've installed using Gradle, you would have already ran your first program and we'll help you understand the project structure in the [Gradle Project Structure](#gradle-project-structure) section.

If you've installed using any other method, please skip to the [Etlas Project Structure](#etlas-project-structure) section.

## Gradle Project Structure

In the last module, you have cloned the `eta-init` repository which gives you a template project structure to work with.

### Understanding the Layout

The project layout should look like this:

```sh
eta-init
- src
  - main
    - eta
      - Main.hs
      - Primes.hs
- build.gradle
```

There will also be a `gradle` folder and a bunch of `gradlew` files. All these files allow the Gradle Wrapper script to work so that other developers can reproduce your build easily.

### Understanding build.gradle

```groovy
plugins {
    id 'com.typelead.eta' version '0.6.0'
    id 'application'
}

eta {
    version = '0.8.6b1'
    etlasVersion = '1.5.0.0'
}

dependencies {
  compile eta('base:4.11.1.0')
}
```

* The `plugins` block contains information about which plugin to download from the [Gradle Plugin Portal](https://plugins.gradle.org/).

  * The `id 'com.typelead.eta'` line applies the `eta` plugin to the current project. This will allow Gradle to compile your Eta files.
  * The `id 'application'` line applies the `application` plugin to the current project. This will allow you to run the program specified by the `main` function in the `src/main/eta/Main.hs` file.
* The `eta` extension block allows you to configure the versions of Eta and Etlas you would like to use for the project.
* The `dependencies` block lets you specify libraries you would like to use in the project.

### Building and Running

You can use the following command to build & run your project:

```sh
./gradlew run
```

You can follow along with the examples in the upcoming modules by updating the `Main.hs` with your new code and run the `./gradlew run` command to get the output of the new program.

For more information about how to use Gradle and the Eta Plugin, you can check out the [Gradle Plugin User Guide](/docs/user-guides/gradle-user-guide).

## Etlas Project Structure

When working on Eta projects, we use the Etlas build tool to manage our `eta` version and take care of our package management. Etlas also has special features that allow it to patch Haskell packages to be compatible with Eta, an important function we'll discuss later.

We'll show you how to run the `eta` compiler directly and also how to use `etlas` to make our lives easier.

### Running a Program

1.  Create a file with a simple program.

    ### Main.hs

    ```eta
    module Main where

    primes = filterPrime [2..]
      where filterPrime (p:xs) =
              p : filterPrime [x | x <- xs, x `mod` p /= 0]

    main = putStrLn $ "The 101st prime is " ++ show (primes !! 100)
    ```

2.  Compile the program.

    ```sh
    $ etlas exec eta -- Main.hs
    ```

    **NOTE:** The command above is equivalent to

    ```sh
    $ eta Main.hs
    ```

    if you had a global `eta` compiler installed.

    This will compile the program to a standalone JAR with a `Run`- prefix added to the module name.

3.  Run the program with `java`.

    ```sh
    $ java -jar RunMain.jar
    ```

### Setting Up a Project

While you can manage with manually sending flags to the Eta compiler for single-file programs, for large projects, you want a tool that can compile the program taking into account many files and library dependencies.

You can use the Etlas build tool to handle non-trivial projects. You specify configuration for your project by creating a `[project-name].cabal` file at the root of your project.

1.  Create a new directory called `eta-first` and enter it.

    ```sh
    $ mkdir eta-first
    $ cd eta-first
    ```

2.  Initialize the project with Etlas.

    *Note:* `<[text-here]>` means to type `[text-here]` and `<Enter>` means to press the Enter key.

    ```sh
    $ etlas init
    Package name? [default: eta-first] <Enter>
    Package version? [default: 0.1.0.0] <Enter>
    Please choose a license:
      1) GPL-2
      2) GPL-3
      3) LGPL-2.1
      4) LGPL-3
      5) AGPL-3
      6) BSD2
    * 7) BSD3
      8) MIT
      9) ISC
      10) MPL-2.0
      11) Apache-2.0
      12) PublicDomain
      13) AllRightsReserved
      14) Other (specify)
    Your choice? [default: BSD3] <Enter>
    Author name? [default: ...] <Enter>
    Maintainer email? [default: ...] <Enter>
    Project homepage URL? <Enter>
    Project synopsis? <Enter>
    Project category:
    * 1) (none)
      2) Codec
      3) Concurrency
      4) Control
      5) Data
      6) Database
      7) Development
      8) Distribution
      9) Game
      10) Graphics
      11) Language
      12) Math
      13) Network
      14) Sound
      15) System
      16) Testing
      17) Text
      18) Web
      19) Other (specify)
    Your choice? [default: (none)] <Enter>
    What does the package build:
      1) Library
      2) Executable
    Your choice? <2>
    What is the main module of the executable:
    * 1) Main.hs (does not yet exist, but will be created)
      2) Main.lhs (does not yet exist, but will be created)
      3) Other (specify)
    Your choice? [default: Main.hs (does not yet exist, but will be created)] <Enter>
    Source directory:
    * 1) (none)
      2) src
      3) Other (specify)
    Your choice? [default: (none)] <2>
    What base language is the package written in:
    * 1) Haskell2010
      2) Haskell98
      3) Other (specify)
    Your choice? [default: Haskell2010] <Enter>
    Add informative comments to each field in the cabal file (y/n)? [default: n] <Enter>

    Guessing dependencies...

    Generating LICENSE...
    Generating Setup.eta...
    Generating ChangeLog.md...
    Generating src/Main.hs...
    Generating eta-first.cabal...
    ```

    The project structure should look like this:

    ```sh
    eta-first
    - src
      - Main.hs
    - ChangeLog.md
    - LICENSE
    - Setup.hs
    - eta-first.cabal
    ```

3.  Add the files `Main.hs` and `Primes.hs` in `src/` as shown below.

    ### Main.hs

    ```eta
    module Main where

    import Primes

    main = putStrLn $ "The 101st prime is " ++ show (primes !! 100)
    ```

    ### Primes.hs

    ```eta
    module Primes where

    primes = filterPrime [2..]
      where filterPrime (p:xs) =
              p : filterPrime [x | x <- xs, x `mod` p /= 0]
    ```

4.  Update `eta-first.cabal`, adding an `other-modules: Primes` field.

    ### eta-first.cabal
    ```sh
    name:                eta-first
    version:             0.1.0.0
    license:             BSD3
    license-file:        LICENSE
    author:              [your name]
    maintainer:          [your email]
    build-type:          Simple
    extra-source-files:  ChangeLog.md
    cabal-version:       >=1.10

    executable eta-first
      main-is:             Main.hs
      other-modules:       Primes
      build-depends:       base >=4.8 && <4.9
      hs-source-dirs:      src
      default-language:    Haskell2010
    ```

    Any additional modules you add to the project should be added at the same indentation level as the `Primes` entry, but below it.

5.  Build & run your program.

    ```sh
    $ etlas run
    ```
    
For more information on how to use Etlas, you can visit the [Etlas User Guide](/docs/user-guides/etlas-user-guide).

## Next Section

Now that we've built our first project, the next section will cover the language.
