#!/bin/csh
source ~/cshrc 
xrun -f file.f -access +rwc -uvm +SVSEED=random -gui
