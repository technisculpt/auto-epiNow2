# auto-epiNow2

Sequentially run a folder of datasets through epiNow2, show stdout to screen & log it to a file

### Assuming you are set up to run epiNow2 and familiar with it

* Make a folder called input
* Place your datasets in it and run "schedule_epinow2.py"
* Each dataset will get a detailed log file and output will appear in a folder named results
* Change cores/chains parameters to epinow in templating/build_epinow, I have set cores and chains set to 12 by default, 16 cores almost melted my computer
* For other parameters see templating/base.R

![alt text](https://github.com/technisculpt/auto-epiNow2/blob/main/summary_example.png)