package shell

import (
	"bytes"
	"fmt"
	"io"
	"os"
	"os/exec"

	"github.com/charmbracelet/log"
)

var ErrNoShell error = fmt.Errorf("$SHELL not found or empty")

// Run takes a command to run in a shell and the following arguments
// are used for formatting the command itself.
func Run(cmd string, args ...any) ([]byte, []byte, error) {
	stdout := bytes.NewBuffer(make([]byte, 0))
	stderr := bytes.NewBuffer(make([]byte, 0))
	err := run(stdout, stderr, nil, cmd, args...)

	return stdout.Bytes(), stderr.Bytes(), err
}

func Exec(cmd string, args ...any) error {
	return run(os.Stdout, os.Stderr, os.Stdin, cmd, args...)
}

func run(stdout, stderr io.Writer, stdin io.Reader, cmd string, args ...any) error {
	shell, ok := os.LookupEnv("SHELL")
	if !ok || shell == "" {
		return ErrNoShell
	}

	cmd = fmt.Sprintf(cmd, args...)
	c := exec.Command(shell, "-c", cmd)
	c.Stdout = stdout
	c.Stderr = stderr
	c.Stdin = stdin

	log.Debug("shell.run", "command", fmt.Sprintf("%s %s %s", shell, "-c", cmd))
	return c.Run()
}
