FanGraphs’ Variable Names and Definitions
================
Alex Rados
5/7/2020

Below are the variable names and their defintions. The first variable
will be the one seen in R studio, the definition will follow, then in
paranetheses will be what the variable actually is according to
FanGraphs (as downloading them into R alters the naming).

  - Name: Player name
  - Team: Team name
  - BB.: Walk percentage (BB%)
  - BB.K: Walk to strikeout ratio (BB/K)
  - OBP: On base percentage
  - SLG: Slugging percentage
  - OPS: On base plus slugging percentage
  - ISO: Isolated power
  - BABIP: Batting average on balls in play
  - GB.FB: Ground ball to fly ball ratio (GB/FB)
  - LD.: Line drive percentage (LD%)
  - GB.: Ground ball percentage (GB%)
  - FB.: Fly ball percentage (FB%)
  - IFFB.: Infield fly ball percentage (IFFB%)
  - HR.FB: Home run to fly ball ratio (HR/FB)
  - wOBA: Weighted on base average
  - wRAA: Runs above average based on wOBA
  - wRC: Runs created based on wOBA
  - Bat: Park adjusted runs above average based on wOBA (Batting)
  - Fld: Fielding runs above average based on UZR (Fielding)
  - Rep: Replacement runs set at 20 runs per 600 plate appearances
    (Replacement)
  - Pos: Positional adjustment (Positional)
  - RAR: Runs above replacement (Batting + Fielding + Replacement + Base
    Running + Positional)
  - Spd: Speed score (Speed)
  - wRC.: Runs per PA scaled where 100 is average; both league and park
    adjusted; based on wOBA (wRC+)
  - WPA: Win probability added
  - X.WPA: Negative win probability added (-WPA)
  - X.WPA.1: Positive win probability added (+WPA)
  - RE24: Runs above average based on the 24 base/out states
  - REW: Wins above average based on the 24 base/out states
  - pLI: Average leverage index
  - phLI: Average leverage index while pinch hitting
  - PH: Pinch hit opportunities
  - WPA.LI: Situational wins (WPA/LI)
  - Clutch: How much better or worse a player does in high leverage
    situations than he would’ve done in a context neutral environment
  - O.Swing.: Percentage of pitches a batter swings at outside the
    strike zone, baseball info solutions (O-Swing%)
  - Z.Swing.: Percentage of pitches a batter swings at inside the strike
    zone, baseball info solutions (Z-Swing%)
  - Swing.: Total percentage of pitches a batter swings at, baseball
    info solutions (Swing%)
  - O.Contact.: Percentage of times a batter makes contact with the ball
    on pitches outside the strike zone, baseball info solutions
    (O-Contact%)
  - Z.Contact.: Percentage of times a batter makes contact with the ball
    on pitches inside the strike zone, baseball info solutions
    (Z-Contact%)
  - Contact.: Total percentage of times a batter makes contact with the
    ball, baseball info solutions (O-Contact%)
  - Zone.: Percentage of pitches seen in the strike zone, baseball info
    solutions (Zone%)
  - F.Strike.: First pitch strike percentage, baseball info solutions
    (F-Strike%)
  - SwStr.: Swinging strike percentage (SwStr%)
  - BsR: Base running runs above average (Base Running)
  - O.Swing…pfx.: Percentage of pitches a batter swings at outside the
    strike zone, PITCHf/x (O-Swing% (pfx))
  - Z.Swing…pfx.: Percentage of pitches a batter swings at inside the
    strike zone, PITCHf/x (Z-Swing% (pfx))
  - Swing…pfx.: Total percentage of pitches a batter swings at, PITCHf/x
    (Swing% (pfx))
  - O.Contact…pfx.: Percentage of times a batter makes contact with the
    ball on pitches outside the strike zone, PITCHf/x (O-Contact% (pfx))
  - Z.Contact…pfx.: Percentage of times a batter makes contact with the
    ball on pitches inside the strike zone, PITCHf/x (Z-Contact% (pfx))
  - Contact…pfx.: Total percentage of times a batter makes contact with
    the ball, PITCHf/x (O-Contact% (pfx))
  - Zone…pfx.: Percentage of pitches seen in the strike zone, PITCHf/x
    (Zone% (pfx))
  - Def: Fielding and positional adjustment combined (Defense)
  - wSB: Stolen bases and caught stealing runs above average
  - UBR: Ultimate base running in runs above average, doesn’t include SB
    or CS
  - Off: Batting and base running combined (Offense)
  - Soft.: Soft contact percentage (Soft%)
  - Med.: Medium contact percentage (Med%)
  - Hard.: Hard contact percentage (Hard%)
  - O.Swing…pi.: Percentage of pitches a batter swings at outside the
    strike zone, pitch info (O-Swing% (pi))
  - Z.Swing…pi.: Percentage of pitches a batter swings at inside the
    strike zone, pitch info (Z-Swing% (pi))
  - Swing…pi.: Total percentage of pitches a batter swings at, pitch
    info (Swing% (pi))
  - O.Contact…pi.: Percentage of times a batter makes contact with the
    ball on pitches outside the strike zone, pitch info (O-Contact%
    (pi))
  - Z.Contact…pi.: Percentage of times a batter makes contact with the
    ball on pitches inside the strike zone, pitch info (Z-Contact% (pi))
  - Contact…pi.: Total percentage of times a batter makes contact with
    the ball, pitch info (O-Contact% (pi))
  - Zone…pi.: Percentage of pitches seen in the strike zone, pitch info
    (Zone% (pi))
  - FRM: Framing competency by the catcher
  - AVG.: Batting average, league and park adjusted (AVG+)
  - BB..: Walk percentage, league and park adjusted (BB+)
  - K..: Strikeout percentage, league and park adjusted (K+)
  - OBP.: On base percentage, league and park adjusted (OBP+)
  - SLG.: Slugging percentage, league and park adjusted (SLG+)
  - ISO.: Isolated power, league and park adjusted (ISO+)
  - BABIP.: Batting average on balls in play, league and park adjusted
    (BABIP+)
  - LD..: Line drive percentage, league and park adjusted (LD+)
  - GB..: Ground ball percentage, league and park adjusted (GB+)
  - FB..: Fly ball percentage, league and park adjusted (FB+)
  - HR.FB..: Home run to fly ball ratio, league and park adjusted
    (HR/FB+)
  - Pull..: Pull percentage, league and park adjusted (Pull+)
  - Cent..: Center of the field contact percentage, league and park
    adjusted (Cent+)
  - Oppo..: Opposite field contact percentage, league and park adjusted
    (Oppo+)
  - Soft..: Soft contact percentage, league and park adjusted (Soft+)
  - Med..: Medium contact percentage, league and park adjusted (Med+)
  - Hard..: Hard contact percentage, league and park adjusted (Hard+)
  - playerid: Player id number
  - WAR: Wins above replacement player
  - IP: Innings pitched
  - K.9: Strikeouts per nine innings (K/9)
  - H.9: Hits given up per nine innings (H/9)
  - BB.9: Walks given up per nine innings (BB/9)
  - HR.9: Home runs given up per nine innings (HR/9)
  - LOB.: Left on base percentage (LOB%)
  - FIP: Fielder independent pitching on an ERA scale
  - tERA: True runs allowed
  - xFIP: Expected fielder independent pitching on an ERA scale
  - inLI: Average leverage index at the start of the inning
  - gmLI: Average leverage index when entering the game
  - exLI: Average leverage index when exiting the game
  - ERA.: Earned runs average, league and park adjusted (ERA+)
  - FIP.: Fielder independent pitching, league and park adjusted (FIP+)
  - xFIP.: Expected fielder independent pitching, league and park
    adjusted (xFIP+)
  - SIERA: Skill interactive ERA
  - RS.9: Run support per nine innings (RS/9)
  - K.BB.: Strikeout to walk ratio (K/BB)
  - kwERA: Strikeout and walk-based earned runs average estimate
  - K.9.: Strikeouts per nine innings, league and park adjusted (K/9+)
  - BB.9.: Walks given up per nine innings, league and park adjusted
    (BB/9+)
  - K.BB..1: Strikeout to walk ratio, league and park adjusted (K/BB+)
  - H.9.: Hits given up per nine innings, league and park adjusted
    (H/9+)
  - HR.9.: Home runs given up per nine innings, league and park adjusted
    (HR/9+)
  - WHIP.: Walks plus hits per innings pitched, league and park adjusted
    (WHIP+)
  - LOB..: Left on base percentage, league and park adjusted (LOB%+)