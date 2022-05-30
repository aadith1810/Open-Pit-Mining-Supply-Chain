
UPDATE `cycledata`
SET `Loading Efficiency` = 75.65
WHERE `Loading Efficiency` IS NULL; 

UPDATE `cycledata`
SET `Dumping Duration` = 42.86
WHERE `Dumping Duration` IS NULL; 

update `cycledata`
set `Dumping SMU Duration` = 36.33
where `Dumping SMU Duration` IS null;

update `cycledata`
set	`Empty Travel Duration` = 610
where `Empty Travel Duration` = 878;

update `cycledata`
set `tmph` = 73784.62
where `tmph` IS null;

-- Creating Equipment Master Table
Create table Equipment_Master AS
select
`Primary Machine Name`, `Primary Machine Class Name`, 
`Secondary Machine Name`,`Secondary Machine Class Name`,
 `Loading Count`,`iMine Load FCTR Truck`, `PREVIOUSSECONDARYMACHINE`,
 `PREVIOUSSINKDESTINATION`, `End Processor Name`, `iMine Engine Hours`,
 `iMine Operating Hours`, `OPERATINGTIME (CAT)`, `OPERHOURSSECONDS`,
 `Full Travel Duration`, `Empty Travel Duration`,`Idle Duration`, 
 `Loading Duration`, `WAITFORDUMPDURATION`, `Dumping Duration`,
 `Payload (kg)`, `Estimated Fuel Used`,	`Fuel Used`, `Loading Efficiency`,
 `OPERATINGBURNRATE`, `TMPH`,`Job Code Name`
FROM cycledata;

-- Creating Equipment_Type_Master Table

Create table Equipment_Type_Master As
select
`Cycle Type`, `Primary Machine Category Name`,
`Secondary Machine Category Name`,
`TC`, `AT Available Time (iMine)`, `Available SMU Time`, `Cycle Duration`,
`Cycle SMU Duration`,
`Down Time`, `Completed Cycle Count`, `iMine Availability`, `iMine Utilisation`, `Job Type`
from cycledata;


-- Creating Location_Master Table
Create table Location_Master As
select
`Source Location Name`, `Destination Location Name` , `Queuing at Sink Duration`
`Queuing at Source Duration`, `Queuing Duration`,`Cycle End Timestamp (GMT8)`,
`Cycle Start Timestamp (GMT8)` ,
`Source Loading Start Timestamp (GMT8)`,
`Source Loading End Timestamp (GMT8)`
from cycledata;

-- Creating movement_data Table
 Create table Movement_data As
select `Primary Machine Name` , `Secondary Machine Name`, 
`Source Location Name` , `Destination Location Name`, `Payload (kg)`, `Cycle Start Timestamp (GMT8)`,
`Cycle End Timestamp (GMT8)`, row_number () over () as `movement id` 
from cycledata;

-- Creating Location_Type_Master Table
Create table Location_Type_Master As
select
`Source Location Description`, `Destination Location Description`,
`Empty EFH Distance` , `Empty Slope Distance` , `Queuing at Sink Duration`,
`Queuing at Source Duration` , `Queuing Duration`, `Source Location is Active Flag`,
`Source Location is Source Flag`,
`Destination Location is Active Flag`,
`Destination Location is Source Flag`
from cycledata; 



Delimiter $$
CREATE PROCEDURE `cycle_data1` ()
BEGIN
select
`Primary Machine Name`,
`Primary Machine Class Name`,
`Secondary Machine Name` ,
`Secondary Machine Class Name`,
`Loading Count`, `Cycle Type` ,
`TC`,
`Cycle Duration` , `Cycle SMU Duration` , `iMine Engine Hours`,
`iMine Operating Hours` ,
`OPERATINGTIME (CAT)`, `OPERHOURSSECONDS`,
`Cycle Start Timestamp (GMT8)` , `Cycle End Timestamp (GMT8)`,
`Payload (kg)` , `Empty EFH Distance` , `Completed Cycle Count`,
`iMine Availability` , `iMine Utilisation`
From cycledata;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `Movement_Data`()
BEGIN
select
`Source Location Name`,`Destination Location Name`,`Source Loading Start Timestamp (GMT8)`,
`Source Loading End Timestamp (GMT8)`,`Source Location Description`,
`Destination Location Description`,`Empty EFH Distance`,`Empty Slope Distance`,
`Source Location is Active Flag`,`Source Location is Source Flag`, 
`Destination Location is Active Flag`,`Destination Location is Source Flag`,
`Full Travel Duration`, `Empty Travel Duration`,`Idle Duration`, 
`Loading Duration`, `WAITFORDUMPDURATION`, `Dumping Duration`
from cycledata;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `Delay_data1`()
BEGIN
Select 
`Down Time`,
`Queuing at Source Duration`,`Queuing Duration`,`Queuing at Sink Duration`,
`Queuing at Source Duration`,`Queuing Duration`,
`Empty Travel Duration`,`Idle Duration`, `Loading Duration`, `WAITFORDUMPDURATION`,
`Dumping Duration`
from cycledata;
END$$
DELIMITER ;


Create table OEE As 
select 
`AT Available Time (iMine)`,`Down Time`,`iMine Operating Hours`,`OPERATINGTIME (CAT)`,
`Idle Duration`, 
(((`AT Available Time (iMine)`-`Down Time`)/nullif(`AT Available Time (iMine)`,0))*100) as Availability,
(((`OPERATINGTIME (CAT)`-`Idle Duration`)/nullif(`OPERATINGTIME (CAT)`,0))*100) as Performance, 
(((`iMine Operating Hours`-`Down Time`)/(nullif(`Down Time`+ `Idle Duration`,0)))*100) as Quailty
 from cycledata;
 
 select * from OEE
  
  select * from oee
DELIMITER $$
CREATE PROCEDURE `OEE_Calculations`()
BEGIN
select 
`AT Available Time (iMine)`,
  `Down Time`,
  `iMine Operating Hours`,
  `OPERATINGTIME (CAT)`,
  `Idle Duration`,
  `Availability`,
  `Performance`,
  `Quailty` ,
  (`Availability`*  `Performance`*  `Quailty` ) as OEE
from oee ;
END$$
DELIMITER ;





