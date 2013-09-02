{-# LANGUAGE MagicHash, BangPatterns #-}
module Main where
import Data.Array.Repa.Series           as R
import Data.Array.Repa.Series.Series    as S
import Data.Array.Repa.Series.Vector    as V
import Data.Array.Repa.Series.Ref       as Ref
import qualified Data.Vector.Primitive  as P
import Data.Word
import GHC.Exts

---------------------------------------------------------------------
-- | Set the primitives used by the lowering transform.
repa_primitives :: R.Primitives
repa_primitives =  R.primitives


---------------------------------------------------------------------
main
 = do   v1      <- V.fromPrimitive $ P.enumFromN (1 :: Float) 100
        let rn  =  RateNat (int2Word# 100#)

        r1      <- Ref.new 666
        R.runProcess v1 (lower_rreduce rn r1)
        x1      <- Ref.read r1
        print x1


-- Double reduce fusion.
--  Computation of both reductions is interleaved.
lower_rreduce :: RateNat k -> Ref Float -> Series k Float -> Process
lower_rreduce _ ref1 s
 =      R.reduce ref1 (+) 0 s 
 %      R.reduce ref2 (*) 1 s
{-# NOINLINE lower_rreduce #-}

