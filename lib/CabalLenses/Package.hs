{-# LANGUAGE TemplateHaskell, TypeFamilies, FlexibleInstances, MultiParamTypeClasses #-}

-- |
-- Lenses for several data types of the 'Distribution.Package' module.
-- All lenses are named after their field names with a 'L' appended.

module CabalLenses.Package where

import Distribution.Package (PackageIdentifier(..) , Dependency(..))
import Distribution.Types.PackageName
import Distribution.Version (VersionRange)
import Control.Lens


makeLensesFor [ ("pkgName"   , "pkgNameL")
              , ("pkgVersion", "pkgVersionL")
              ] ''PackageIdentifier


instance (t ~ PackageName) => Rewrapped PackageName t
instance Wrapped PackageName where
  type Unwrapped PackageName = String
  _Wrapped' = iso getPackageName mkPackageName
     where
        getPackageName pkg = unPackageName pkg
  {-# INLINE _Wrapped' #-}


packageName :: Lens' Dependency PackageName
packageName = lens getPkgName setPkgName
   where
      getPkgName (Dependency pkgName _)          = pkgName
      setPkgName (Dependency _ range) newPkgName = Dependency newPkgName range


versionRange :: Lens' Dependency VersionRange
versionRange = lens getRange setRange
   where
      getRange (Dependency _ range)   = range
      setRange (Dependency pkgName _) = Dependency pkgName
