package docker

import (
	"errors"

	"github.com/tangledbytes/dotfiles/devenv2/pkg/shell"
)

type ContainerStatus int

const (
	NotExist ContainerStatus = iota
	Stopped
	Running
)

// Status returns the status of the given container
func Status(container string) (ContainerStatus, error) {
	stdout, stderr, err := shell.Run("docker container ls -a --filter \"name=%s\" -q", container)
	if err != nil {
		return NotExist, errors.New(string(stderr))
	}

	containerID := string(stdout)
	if containerID != "" {
		stdout, stderr, err = shell.Run("docker container inspect -f '{{.State.Running}}' %s", container)
		if err != nil {
			return NotExist, errors.New(string(stderr))
		}

		isRunning := string(stdout)
		if isRunning == "true" {
			return Running, nil
		}

		return Stopped, nil
	}

	return NotExist, nil
}

func Build(dockerfile, arch, tag string) error {
	if _, stderr, err := shell.Run("echo \"%s\" | docker build --platform linux/%s -t %s -", dockerfile, arch, tag); err != nil {
		return errors.New(string(stderr))
	}

	return nil
}
