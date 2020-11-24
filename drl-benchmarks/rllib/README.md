The examples in `tuned_examples` come directly from the RLLib git repo.

https://github.com/ray-project/ray/tree/master/rllib/tuned_examples

You can change the example you want to run by changing `$TUNED_EXAMPLE` in the 
`../reference/submit-example.sh` script.

The examples tested and verified to work on Eagle are:

* `tuned_exmaples/dqn/cartpole-dqn.yaml`: good for debugging, learns extremely quickly (~1 minute)
* `tuned_examples/dqn/breakout-dqn.yaml`: harder example, takes longer to learn.

Common things that you might want to configure in the example yaml files:

* Top level:

  * `local_dir`:  Add this to change the location of output logs (defaults to `~/ray_results`)

  * `config`
      * `num_gpus`: number of GPUs used for training.  Can be fractional, > 1, 
         etc. as long sufficient resources were requested in the submit script.
      * `num_workers`:  number of rollout workers, can be as many as number of 
         available CPUs minus 1.
         
  * `stop`:  Add stopping criteria, e.g.,
      * `episode_reward_mean`: episode reward mean threshold, stop when reached
      * `time_total_s`: stop after this many seconds of training
      
See [this page](https://docs.ray.io/en/master/rllib-training.html) for more details on the RLLib training API.


* Example runs:

There are three example runs included `../reference`.  The input files are zero.yml, one.yml, two.yml with run scripts dozero.slurm, doone.slurm,
and dotwo.slurm.  These input files are based on the file tuned_examples/dqn/breakout-dqn.yaml.  They add the following stop condition:

```
    stop: 
        time_total_s: 7200
```

along with a path to their output directory and GPU count.  That is:

```
el1:reference> diff zero.yml one.yml 
4c4
<     local_dir: /scratch/tkaiser2/zero
---
>     local_dir: /scratch/tkaiser2/one
32c32
<         num_gpus: 0 
---
>         num_gpus: 1 
el1:reference> diff zero.yml two.yml 
4c4
<     local_dir: /scratch/tkaiser2/zero
---
>     local_dir: /scratch/tkaiser2/two
32c32
<         num_gpus: 0 
---
>         num_gpus: 2 
el1:reference> 

```

Jobs run for 7200 seconds on either 0, 1, or 2 GPUS with outputs going in the
named directory.  Clearly you will need to change the path to the output directory.

The output directories zero, one, and two are archived in the file `../reference/rawresults.tgz`.

The slurm scripts are `../reference/do[zero,one,two].slurm` with stdout in files `../reference/slurm-503300[2,4,5]`.  The `../reference/times.*`
files are produced by the script tymer.  This step is not required.  

The Env setup portion of the runscript could be simplifed.  The complications are the result of this particular user's Anaconda setup.  The files `../reference/slimgpu.yaml` and `../reference/env.yaml` are known to create working environments on NREL's platform Eagle, and are provided for reference.

The runs produce `progress.csv` files in the target directories, e.g., `[zero,one,two]/breakout/DQN...`.

The python script `../reference/ray.py` extracts the columns 

```
training_iteration, episode_reward_mean, time_total_s
```

from these files and produces the files total.csv and total.xlsx, and plots of the data.  The plots are not required in the Offeror's response.

There are two additional columns in total.csv and total.xlsx:

```
Node Description   Optimization
```

* Expectations:

Vendors should run the example using the file zero.yml as the basis of input, that is using CPUs only, and one.yml to run on a single GPU.  Vendors are encouraged to run on additional GPUs including, if desired, GPUs spread across multiple nodes.  

Vendors should report 

```
Node Description, Optimization, training_iteration, episode_reward_mean, time_total_s
```

The initial runs should be done without modifying the base code.  Optionally, vendors may desire to optimize the code.  

The column Node Description should contain text like: "Standard", or "Large Data"

There is a column for GPU count, which should contain the total number of GPUs used for the reported run in that Spreadsheet row.

The Optimization column should contain "As-is" for the base code or if optimizations are performed they should be noted here.

A run is valid if there is a positive overall slope of episode_reward_mean, it runs for 7200 seconds or completes, and all files are created in the output directory.  The script `../validate.py` attempts to check this, and can also be used to produce the final output files for a single run.

**We note that on occasion, when the code is terminated with**  **

```
    stop: 
        time_total_s: 7200
```

**it core dumps.  This is not a disqualifier or held against the vendor.**  


Response
========
The File Response should include run scripts, input files, environmental dumps, stdout and stderr, a *tgz file containing the output directories, and an .

The Text Response should include environmental descriptions and more extensive descriptions of code optimizations as needed.

The Spreadsheet Response should resemble the example Excel file provided here.  
