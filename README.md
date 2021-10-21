# Advanced-Computer-Architectures
Course material for Advanced Computer Architectures course.

## Getting started with the repo

### Fork the repository

Fork the repo using the proper button, as shown below:

![Alt Text](https://github.com/PARCO-LAB/Advanced-Computer-Architectures/blob/main/figures/fork.png)

### Clone your fork
To be able to work on the project, you will need to clone it to the device.

Copy the path, as shown below:

![Cloning](https://github.com/PARCO-LAB/Advanced-Computer-Architectures/blob/main/figures/clone.png)

Create a folder with your name and surname, then 

```
mkdir ACA/<name>_<surname>
git clone <link copied from GitHub>
```

### Compile the excercise


### Benchmarking

```
std::cout << TM_host.duration() << ";" << TM_device.duration() << ";" << TM_host.duration() / TM_device.duration() << std::endl;
```

### Do your excercise and save the changes
Go ahead and complete the excercises. When you’re ready to submit your changes, stage and commit your changes.

In the project root folder, type:
```
git add .
git commit -m "<comment to the changes>"
git push
```

In this way, your excercise implementations are saved in your personal GitHub profile.
