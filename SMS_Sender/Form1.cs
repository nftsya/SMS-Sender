using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.IO;
using System.Net;

namespace SMS_Sender
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
            string[] auth = File.ReadAllLines("C:/Users/Настя/source/repos/SMS_Sender/SMS_Sender/Properties/Auth.txt");
            textBox1.Text = auth[0];
            textBox2.Text = auth[1];
        }

        private void button1_Click(object sender, EventArgs e)
        {
            string responseString = "";

                string[] auth = new string[] { textBox1.Text, textBox2.Text };
                if (checkBox1.Checked)
                {
                    File.WriteAllLines("C:/Users/Настя/source/repos/SMS_Sender/SMS_Sender/Properties/Auth.txt", auth);
                }
                //string urlAuth = string.Format("https://{0}:{1}key@gate.smsaero.ru/v2/auth", auth[0], auth[1]);

                var uri = new Uri("https://gate.smsaero.ru/v2/auth");
                var cache = new CredentialCache();
                cache.Add(uri, "Basic", new NetworkCredential(auth[0], auth[1]));

                var request = WebRequest.Create(uri);
                request.Credentials = cache;

                HttpWebResponse response;
                try
                {
                    response = (HttpWebResponse)request.GetResponse();
                }
                catch(WebException ee)
                {
                    response = (HttpWebResponse)ee.Response;
                }
                responseString = new StreamReader(response.GetResponseStream()).ReadToEnd();
            if (!responseString.Contains("Successful authorization"))
                MessageBox.Show(
                 "Проверьте логин и API-key",
                 "Ошибка авторизации",
                 MessageBoxButtons.YesNo,
                 MessageBoxIcon.Information,
                 MessageBoxDefaultButton.Button1,
                 MessageBoxOptions.DefaultDesktopOnly);
            else
            {
                Form2 form = new Form2(auth);
                this.Hide();
                form.ShowDialog();
                this.Show();
            }
        }
    }
}
