{- AUTOCOLLECT.TEST -}
module Test (
{- AUTOCOLLECT.TEST.export -}

) where

import NQB.Network qualified as NQB
import Test.Tasty
import Test.Tasty.HUnit

test = testCase "exception" NQB.test
