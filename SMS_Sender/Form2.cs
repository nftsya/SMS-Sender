using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;
using System.Net;
using System.IO;

namespace SMS_Sender
{
    public partial class Form2 : Form
    {
        //хранилище данных, с которыми можно работать независимо от наличия подключения
        DataSet ds;
        //заполняет DataSet данными из БД
        SqlDataAdapter adapter;

        string connectionString;

        int pageSize = 5; // размер страницы
        int pageNumber = 0; // текущая страница

        public Form2(string[] auth)
        {
            InitializeComponent();


            var uri = new Uri("https://gate.smsaero.ru/v2/balance");
            var cache = new CredentialCache();
            cache.Add(uri, "Basic", new NetworkCredential(auth[0], auth[1]));

            var request = WebRequest.Create(uri);
            request.Credentials = cache;

            HttpWebResponse response = (HttpWebResponse)request.GetResponse();

            var responseString = new StreamReader(response.GetResponseStream()).ReadToEnd();

            label2.Text = responseString.Split('"')[6].Substring(1, responseString.Split('"')[6].IndexOf('}') - 1);
            string[] elements = new string[] { "Скидка", "День рождения", "Конец договора страхования", "Свой текст" };
            comboBox1.Items.AddRange(elements);
            comboBox1.SelectedItem = comboBox1.Items[2];

            dataGridView1.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            dataGridView1.AllowUserToAddRows = false;
        }

        private void button1_Click(object sender, EventArgs e)
        {

        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            string selectedState = comboBox1.SelectedItem.ToString();
            switch (selectedState)
            {
                case "Скидка":
                    label4.Visible = false;
                    textBox3.Visible = false;
                    label6.Visible = false;
                    textBox1.Text = "Скидка -10% на ВСЁ! Действует до конца месяца, спешите!";
                    break;
                case "День рождения":
                    label4.Visible = true;
                    label4.Text = "Введите дату рождения:";
                    textBox3.Visible = true;
                    textBox3.Location = new Point(390, 100);
                    textBox3.Width = 90;
                    label6.Visible = false;
                    textBox1.Text = "<name>, поздравляем с днем рождения! Весь последующий месяц для вас действует скидка -20% на ассортимент автосалона.";
                    break;
                case "Конец договора страхования":
                    label4.Visible = true;
                    label4.Text = "Только для клиентов, дата окончания договора\nстрахования которых заканчивается через";
                    textBox3.Visible = true;
                    textBox3.Location = new Point(479, 116);
                    textBox3.Width = 30;
                    label6.Visible = true;
                    textBox1.Text = "<name>, срок вашего договора страхования заканчивается <date>. Для продления звоните по телефону +7(962)-364-77-49";
                    break;
                default:
                    label4.Visible = false;
                    textBox3.Visible = false;
                    label6.Visible = false;
                    textBox1.Text = "";
                    break;
            }

        }

        private void button3_Click(object sender, EventArgs e)
        {
            if (pageNumber == 0) return;
            pageNumber--;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                adapter = new SqlDataAdapter(GetSql(), connection);

                ds.Tables[0].Rows.Clear();

                adapter.Fill(ds);
            }

        }
        private void button4_Click(object sender, EventArgs e)
        {
            if (ds.Tables[0].Rows.Count < pageSize) return;

            pageNumber++;
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                adapter = new SqlDataAdapter(GetSql(), connection);

                ds.Tables[0].Rows.Clear();

                adapter.Fill(ds);
            }

        }

        private string GetSql()
        {
            return "SELECT * FROM Users ORDER BY Id OFFSET ((" + pageNumber + ") * " + pageSize + ") " +
                "ROWS FETCH NEXT " + pageSize + "ROWS ONLY";
        }

        private void button2_Click(object sender, EventArgs e)
        {
            if (openFileDialog1.ShowDialog() == DialogResult.Cancel)
                return;
            string filename;
            filename = openFileDialog1.FileName;
            connectionString = @"Data Source=.\SQLEXPRESS01;AttachDbFilename =" + filename + ";Integrated Security=True";

            //using автоматически закрывает подключение
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                adapter = new SqlDataAdapter(GetSql(), connection);

                ds = new DataSet();
                adapter.Fill(ds);
                dataGridView1.DataSource = ds.Tables[0];
                // делаем недоступным столбец id для изменения
                dataGridView1.Columns["Id"].ReadOnly = true;
                dataGridView1.Columns[0].Width = 20;
                dataGridView1.Columns[2].Width = 80;
            }
        }
    }
}
