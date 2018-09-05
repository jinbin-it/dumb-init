# dumb-init
run dumb-init in docker with pid=1 to handle the multiple processes

**Dumb-init**  
dumb-init is a simple process supervisor and init system designed to run as PID 1 inside minimal container environments (such as Docker). It is deployed as a small, statically-linked binary written in C.

Lightweight containers have popularized the idea of running a single process or service without normal init systems like systemd or sysvinit. However, omitting an init system often leads to incorrect handling of processes and signals, and can result in problems such as containers which can't be gracefully stopped, or leaking containers which should have been destroyed.

dumb-init enables you to simply prefix your command with dumb-init. It acts as PID 1 and immediately spawns your command as a child process, taking care to properly handle and forward signals as they are received.

**Application is the background process (not PID1)**  
The process to be signaled could be the background one and you cannot send any signals directly. In this case one solution is to set up a shell-script as the entrypoint and orchestrate all signal processing in that script.

**What i want to do**  
In the project ,user want to operate the container by ssh, thus in the container should run a sshd and a service.  
We choose use init process to run them and handle the signal of application.
