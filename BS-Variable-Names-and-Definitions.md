Baseball Savant’s Variable Names and Definitions
================
Alex Rados
5/7/2020

Below are the variable names and their definitions for Baseball Savant.
The first variable will be the one seen in R studio, the definition will
follow, then in paranetheses will be what the variable actually is
according to Baseball Savant (as downloading them into R alters the
naming).

  - last\_name: Player’s last name
  - first\_name: Player’s first name
  - year: Year for which the counting statistics were accrued
    (everything but WAR)
  - name: Player name
  - xba: Expected batting average
  - xslug: Expected slugging percentage
  - xwoba: Expected weighted on base average
  - xobp: Expected on base percentage
  - xiso: Expected isolated power
  - wobacon: Weighted on base average on contact
  - xwobacon: Expected weighted on base average on contact
  - bacon: Batting average on contact
  - xbacon: Expected batting average on contact
  - xbadiff: Difference between expected and actual batting average on
    contact (BA-xBA)
  - xslugdiff: Difference between expected and actual slugging
    percentages (SLG-xSLG)
  - wobadif: Difference between expected and actual on base averages
    (wOBA-xwOBA)
  - exit\_velocity\_avg: Average exit velocity of balls hit into play
    (AVG EV (MPH))
  - launch\_angle\_avg: Average launch angle of balls hit into play (AVG
    LA (in degrees))
  - sweet\_spot\_percent: Percent of batted ball events with a launch
    angle between 8 and 32 degrees (Sweet Spot %)
  - barrels: A batted ball with the perfect combination of exit velocity
    and launch angle, or the most high-value batted balls. (A barrel has
    a minimum Expected Batting Average of .500 and Expected Slugging
    Percentage of 1.500)
  - barrel\_batted\_rate: Percent of batted ball events with a barrel
    (Barrel %)
  - solidcontact\_percent: Percent of batted ball events with solid
    contact (Solid Contact %)
  - flareburner\_percent: Percent of batted ball events with ending in a
    flare/burner type hit (Flare/Burner %)
  - poorlyunder\_percent: Percent of batted ball events on which the
    player got under the ball (Under %)
  - poorlytopped\_percent: Percent of batted ball events on which the
    player got on top of the ball (Topped %)
  - poorlyweak\_percent: Percent of batted ball events with poor/weak
    contact (Poor/Weak %)
  - hard\_hit\_percent: Percent of batted ball events ending with a hard
    hit (Hard Hit %)
  - z\_swing\_percent: Percentage of pitches a batter swings at inside
    the strike zone (Zone Swing %)
  - z\_swing\_miss\_percent: Percentage of pitches a batter swings and
    misses at inside the strike zone (Zone Swing & Miss %)
  - oz\_swing\_percent: Percentage of pitches a batter swings at outside
    the strike zone (Out of Zone Swing %)
  - oz\_contact\_percent: Percentage of pitches a batter makes contact
    on outside the strike zone (Out of Zone Contact %)
  - out\_zone\_swing\_miss: Number of pitches a batter swings and misses
    at outside the strike zone (Out of Zone Swing & Miss)
  - out\_zone\_swing: Number of pitches a batter swings at outside the
    strike zone (Out of Zone Swings)
  - out\_zone\_percent: Percent of pitches thrown outside of the strike
    zone (Out of Zone %)
  - out\_zone: Number of pitches thrown outside of the strike zone (Out
    of Zone)
  - meatball\_swing\_percent: Percent of meatball pitches (easy to hit,
    right down the middle) swung at (Meatball Swing %)
  - meatball\_percent: Percent of meatball pitches thrown (Meatball %)
  - iz\_contact\_percent: In zone contact percentage (In Zone Contact %)
  - in\_zone\_swing\_miss: Number of pitches in the zone swung and
    missed on (In Zone Swing & Miss)
  - whiff\_percent: Percent of the time swinging and missing (Whiff %)
  - swing\_percent: Percent of the time swinging (Swing %)
  - groundballs\_percent: Percent ground balls (GB%)
  - flyballs\_percent: Percent fly balls (FB%)
  - linedrives\_percent: Percent line drives (LD%)
  - popups\_percent: Percent pop-ups (Popup%)
  - pop\_2b\_sba\_count: Total steals of second base attempted (2B
    Attempts)
  - pop\_2b\_sba: Catcher pop time on total steal attempts of second
    base (Poptime 2B All)
  - pop\_2b\_sb: Catcher pop time on steals of second base (Poptime 2B
    on SB)
  - pop\_2b\_cs: Catcher pop time on caught stealings of second base
    (Poptime 2B on CS)
  - pop\_3b\_sba\_count: Total steals of third base attempted (3B
    Attempts)
  - pop\_3b\_sba: Catcher pop time on total steal attempts of third base
    (Poptime 3B All)
  - pop\_3b\_sb: Catcher pop time on steals of third base (Poptime 3B on
    SB)
  - pop\_3b\_cs: Catcher pop time on caught stealings of third base
    (Poptime 3B on CS)
  - exchange\_2b\_3b\_sba: Exchange from glove to hand on throws for
    steals of second and third base (Exchange)
  - maxeff\_arm\_2b\_3b\_sba: Arm strength on steals of second and third
    base (Arm Strength)
  - n\_outs\_above\_average: Number of outs above the league average,
    defensively, on both plays made and difficulty of said plays (OAA)
  - rel\_league\_reaction\_distance: Feet covered (in any direction) in
    the first 1.5 seconds relative to league average (Reaction)
  - rel\_league\_burst\_distance: Feet covered (in any direction) in the
    second 1.5 seconds relative to league average (Burst)
  - rel\_league\_routing\_distance: Compares feet covered in any
    direction to feet covered in the correct direction over the full
    three seconds relative to league average (Route)
  - rel\_league\_bootup\_distance: Feed covered defensively on a play
    for that individual player compared to league average (Feet vs Avg)
  - f\_bootup\_distance: Amount feet covered defensively on a play for
    that individual player (Feet Covered)
  - n\_bolts: Number of bolts, a run where the Sprint Speed (defined as
    “feet per second in a player’s fastest one-second window”) of the
    runner is at least 30 ft/sec (Bolts)
  - hp\_to\_1b: Time elapsed from the point of bat-on-ball contact to
    the moment the batter reaches first base (HP to 1B)
  - spring\_speed: How many feet per second a player runs in his fastest
    one-second window (Spring Speed)
  - WAR: Wins above replacement
  - oz\_swing\_miss\_percent: Percent of pitches outside the zone swung
    and missed on (Out of Zone Swing & Miss %)
  - pitch\_count\_offspeed: Number of offspeed pitches thrown (\#
    Offspeed)
  - pitch\_count\_fastball: Number of fastballs thrown (\# Fastball)
  - pitch\_count\_breaking: Number of breaking pitches (curveballs,
    sliders, etc.) thrown (\# Breaking)
  - in\_zone\_percent: Percent of pitches in the zone (In Zone %)
  - edge\_percent: Percent of pitches on the edge of the zone (Edge %)
  - f\_strike\_percent: Percent of first pitches in an at-bat that were
    strikes (First Strike %)
  - n: Total pitches (Total Pitches)
  - n\_fastball\_formatted: Percent of pitches that were fastballs
    (Fastball %)
  - fastball\_avg\_speed: Average fastball MPH (Fastball Avg MPH)
  - fastball\_avg\_spin: Average spin on the fastball (Fastball Avg
    Spin) (measured in revolutions per minute)
  - fastball\_avg\_break\_x: Average horizontal break on the fastball
    (Fastball Avg H Break)
  - fastball\_avg\_break\_z: Average vertical break on the fastball
    (Fastball Avg V Break)
  - fastball\_avg\_break: Average total break on the fastball (Fastball
    Avg Break)
  - fastball\_range\_speed: Range of fastball speed in MPH (Fastball
    Range MPH)
  - n\_breaking\_formatted: Percent of pitches that were breaking
    pitches (Breaking %)
  - breaking\_avg\_speed: Average breaking pitch MPH (Breaking Avg MPH)
  - breaking\_avg\_spin: Average spin on the breaking pitches (Breaking
    Avg Spin) (measured in revolutions per minute)
  - breaking\_avg\_break\_x: Average horizontal break on the breaking
    pitches (Breaking Avg H Break)
  - breaking\_avg\_break\_z: Average vertical break on the breaking
    pitches (Breaking Avg V Break)
  - breaking\_avg\_break: Average total break on the breaking pitches
    (Breaking Avg Break)
  - breaking\_range\_speed: Range of breaking pitches speed in MPH
    (Breaking Range MPH)
  - n\_offspeed\_formatted: Percent of pitches that were offspeed
    pitches (Offspeed %)
  - offspeed\_avg\_speed: Average offspeed pitches MPH (Offspeed Avg
    MPH)
  - offspeed\_avg\_spin: Average spin on the offspeed pitches (Offspeed
    Avg Spin) (measured in revolutions per minute)
  - offspeed\_avg\_break\_x: Average horizontal break on the offspeed
    pitches (Offspeed Avg H Break)
  - offspeed\_avg\_break\_z: Average vertical break on the offspeed
    pitches (Offspeed Avg V Break)
  - offspeed\_avg\_break: Average total break on the offspeed pitches
    (Offspeed Avg Break)
  - offspeed\_range\_speed: Range of offspeed pitches speed in MPH
    (Offspeed Range MPH)
  - p\_formatted\_ip: Number of innings pitched
