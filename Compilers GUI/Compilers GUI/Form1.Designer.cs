namespace Compilers_GUI
{
    partial class mainWindow
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(mainWindow));
            this.openBtn = new System.Windows.Forms.Button();
            this.saveBtn = new System.Windows.Forms.Button();
            this.compileBtn = new System.Windows.Forms.Button();
            this.openLbl = new System.Windows.Forms.Label();
            this.saveLbl = new System.Windows.Forms.Label();
            this.compilerBtn = new System.Windows.Forms.Button();
            this.compilerLbl = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // openBtn
            // 
            this.openBtn.Location = new System.Drawing.Point(130, 110);
            this.openBtn.Name = "openBtn";
            this.openBtn.Size = new System.Drawing.Size(200, 25);
            this.openBtn.TabIndex = 0;
            this.openBtn.Text = "Open C file";
            this.openBtn.UseVisualStyleBackColor = true;
            this.openBtn.Click += new System.EventHandler(this.openBtn_Click);
            // 
            // saveBtn
            // 
            this.saveBtn.Location = new System.Drawing.Point(130, 180);
            this.saveBtn.Name = "saveBtn";
            this.saveBtn.Size = new System.Drawing.Size(200, 25);
            this.saveBtn.TabIndex = 1;
            this.saveBtn.Text = "Select Save File";
            this.saveBtn.UseVisualStyleBackColor = true;
            this.saveBtn.Click += new System.EventHandler(this.saveBtn_Click);
            // 
            // compileBtn
            // 
            this.compileBtn.Location = new System.Drawing.Point(110, 250);
            this.compileBtn.Name = "compileBtn";
            this.compileBtn.Size = new System.Drawing.Size(240, 40);
            this.compileBtn.TabIndex = 2;
            this.compileBtn.Text = "Compile";
            this.compileBtn.UseVisualStyleBackColor = true;
            this.compileBtn.Click += new System.EventHandler(this.compileBtn_Click);
            // 
            // openLbl
            // 
            this.openLbl.BackColor = System.Drawing.Color.Transparent;
            this.openLbl.Location = new System.Drawing.Point(15, 150);
            this.openLbl.Name = "openLbl";
            this.openLbl.Size = new System.Drawing.Size(455, 20);
            this.openLbl.TabIndex = 3;
            this.openLbl.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // saveLbl
            // 
            this.saveLbl.BackColor = System.Drawing.Color.Transparent;
            this.saveLbl.Location = new System.Drawing.Point(12, 220);
            this.saveLbl.Name = "saveLbl";
            this.saveLbl.Size = new System.Drawing.Size(458, 20);
            this.saveLbl.TabIndex = 4;
            this.saveLbl.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // compilerBtn
            // 
            this.compilerBtn.Location = new System.Drawing.Point(130, 30);
            this.compilerBtn.Name = "compilerBtn";
            this.compilerBtn.Size = new System.Drawing.Size(200, 25);
            this.compilerBtn.TabIndex = 5;
            this.compilerBtn.Text = "Select Your Compiler";
            this.compilerBtn.UseVisualStyleBackColor = true;
            this.compilerBtn.Click += new System.EventHandler(this.compilerBtn_Click);
            // 
            // compilerLbl
            // 
            this.compilerLbl.BackColor = System.Drawing.Color.Transparent;
            this.compilerLbl.Location = new System.Drawing.Point(18, 70);
            this.compilerLbl.Name = "compilerLbl";
            this.compilerLbl.Size = new System.Drawing.Size(452, 20);
            this.compilerLbl.TabIndex = 6;
            this.compilerLbl.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // mainWindow
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("$this.BackgroundImage")));
            this.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Center;
            this.ClientSize = new System.Drawing.Size(482, 304);
            this.Controls.Add(this.compilerLbl);
            this.Controls.Add(this.compilerBtn);
            this.Controls.Add(this.saveLbl);
            this.Controls.Add(this.openLbl);
            this.Controls.Add(this.compileBtn);
            this.Controls.Add(this.saveBtn);
            this.Controls.Add(this.openBtn);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MaximizeBox = false;
            this.Name = "mainWindow";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Compilers GUI";
            this.TransparencyKey = System.Drawing.Color.Red;
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button openBtn;
        private System.Windows.Forms.Button saveBtn;
        private System.Windows.Forms.Button compileBtn;
        private System.Windows.Forms.Label openLbl;
        private System.Windows.Forms.Label saveLbl;
        private System.Windows.Forms.Button compilerBtn;
        private System.Windows.Forms.Label compilerLbl;
    }
}

