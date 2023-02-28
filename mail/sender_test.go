package mail

import (
	"testing"

	"github.com/Nuriddin-Olimjon/simplebank/util"
	"github.com/stretchr/testify/require"
)

func TestSendEmailWithGmail(t *testing.T) {
	if testing.Short() {
		t.Skip()
	}

	config, err := util.LoadConfig("..")
	require.NoError(t, err)

	sender := NewGmailSender(config.EmailSenderName, config.EmailSenderAddress, config.EmailSenderPassword)

	subject := "A test email from Simple Bank"
	content := `
	<h1>Hello world</h1>
	<p>This is a test message from <a href="https://google.com">Simple Bank Service</a></p>
	`

	to := []string{"nuriddin.obidjonov7777@gmail.com", "nuriddin_obidjonov@mail.ru"}
	attachFiles := []string{"../start.sh"}

	err = sender.SendEmail(subject, content, to, nil, nil, attachFiles)
	require.NoError(t, err)
}
