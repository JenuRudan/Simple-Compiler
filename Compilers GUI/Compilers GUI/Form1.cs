using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Diagnostics;
using System.IO;


namespace Compilers_GUI
{
    public partial class mainWindow : Form
    {
        private String openedFile;
        private String savedFile;
        private String compilerFile;
        private bool openedFlag;
        private bool savedFlag;
        private bool compilerFlag;

        public mainWindow()
        {
            InitializeComponent();
            compileBtn.Enabled = false;
            openedFlag = false;
            savedFlag = false;
            openLbl.Visible = false;
            saveLbl.Visible = false;
            compilerLbl.Visible = false;
        }

        private void openBtn_Click(object sender, EventArgs e)
        {
            OpenFileDialog openDialogue = new OpenFileDialog();
            openDialogue.Filter = "C File (*.c) | *.c";

            if (openDialogue.ShowDialog() == DialogResult.OK)
            {
                openedFile = openDialogue.FileName.ToString();
                openedFlag = true;
                openLbl.Text = openedFile;
                openLbl.Visible = true;
            }

            checkFiles();
        }

        private void saveBtn_Click(object sender, EventArgs e)
        {
            SaveFileDialog saveDialogue = new SaveFileDialog();
            saveDialogue.Filter = "Text Files (*.txt) | *.txt";

            if (saveDialogue.ShowDialog() == DialogResult.OK)
            {
                savedFile = saveDialogue.FileName.ToString();
                savedFlag = true;
                saveLbl.Text = savedFile;
                saveLbl.Visible = true;
            }

            checkFiles();
        }

        private void compileBtn_Click(object sender, EventArgs e)
        {
            var lastLine = File.ReadLines(openedFile).Last();
            if (lastLine.ToString() != "endprogram")
                File.AppendAllText(openedFile, "\nendprogram" + Environment.NewLine);
            
            ProcessStartInfo start = new ProcessStartInfo();
            start.Arguments = "/C \"" + compilerFile + " < "+openedFile;
            start.FileName = "cmd.exe";
            start.UseShellExecute = false;
            start.RedirectStandardInput = true;
            start.RedirectStandardOutput = true;

            Process process = new Process();
            process.StartInfo = start;
            StreamWriter writetext = new StreamWriter(savedFile);

            process.Start();
            String x = "";
            while (!process.StandardOutput.EndOfStream)
            {
                x = process.StandardOutput.ReadLine();
                writetext.WriteLine(x + "\n");
            }
            process.WaitForExit();
            writetext.Close();
            MessageBox.Show("Compilation Finished");
        }

        private void checkFiles()
        {
            if (openedFlag && savedFlag && compilerFlag)
                compileBtn.Enabled = true;
        }

        private void compilerBtn_Click(object sender, EventArgs e)
        {
            OpenFileDialog openDialogue = new OpenFileDialog();
            openDialogue.Filter = "EXE File (*.exe) | *.exe";

            if (openDialogue.ShowDialog() == DialogResult.OK)
            {
                compilerFile = openDialogue.FileName.ToString();
                compilerFlag = true;
                compilerLbl.Text = compilerFile;
                compilerLbl.Visible = true;
            }

            checkFiles();
        }
    }
}
