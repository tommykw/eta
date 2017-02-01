{-# LANGUAGE NoImplicitPrelude, MagicHash, UnboxedTuples #-}
-----------------------------------------------------------------------------
-- |
-- Module      :  Java.TopHandler
-- Copyright   :  (c) Rahul Muttineni 2017
--
-- License     :  BSD-style (see the file libraries/base/LICENSE)
--
-- Maintainer  :  rahulmutt@gmail.com
-- Stability   :  provisional
-- Portability :  portable
--
-- For use in exports and wrappers.
--
-----------------------------------------------------------------------------

module Java.TopHandler ( runJava ) where

import GHC.Base
import GHC.TopHandler

import Control.Exception

runJava :: Java c a -> Java c a
runJava (Java m) = Java $ \o ->
  case catch (IO $ \s -> case m o of
          (# _, a #) -> a `seq` (# s, a #)) topHandler of
    IO n -> case n realWorld# of
      (# _, b #) -> (# o, b #)
