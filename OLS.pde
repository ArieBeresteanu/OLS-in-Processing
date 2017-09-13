/////////////////////////////
/////// Global variables ///
////////////////////////////
int Nobs = 25;
//Observation[] sample = new Observation[Nobs];
DataSet data = new DataSet;
boolean makeSample = true;
int canvasWidth = 670;
int canvasHeight = 570;
int offset = 20;
int focusObs=-1;
float alpha = 1.89;
float beta = 0.72;
float std = 80;
float alpha_hat = 0;
float beta_hat = 0;
float R2=0;
String msg = "";


/////////////////////////////
//////// Classes  //////////
////////////////////////////

class Observation {
	private float x;
	private float y;
	private int c=0;
	private float y_hat;
	private float center;
	private float epsilon;
	
	void display() {
		fill(this.c);
		stroke(234,102,0);
		ellipseR(this.x,this.y,10,10);
	}
	
	void stats(float a, float b, float sumY) {
		this.y_hat = a+b*this.x;
		this.center=this.y-sumY/Nobs;
		this.epsilon=this.y-this.y_hat;
	}
}

class DataSet {
	private int N=Nobs;
	private Observation[] sample = new Observation[Nobs] ;
	private float sx1 = 0;
	private	float sx2 = 0;
	private	float sxy = 0;
	private	float sy1 = 0;
	private float beta_hat=0;
	private float alpha_hat=0;
	private float R2=0;
		
	void create(N) {
		this.Nobs=N;
		for (int i=0; i<this.Nobs; i++) {
			float xpos = (width*0.05)+random()*(0.90*width);
			float ypos = alpha+beta*xpos+randomGaussian()*std; 
			this.sample[i] = new Observation();
			this.sample[i].x=xpos;
			this.sample[i].y=ypos;
		}
	}
	
	void calcStats() {
		this.sx1=0;
		this.sx2=0;
		this.sxy=0;
		this.sy1=0;
		for (int i=0; i<Nobs; i++) {
			this.sx1 +=this.sample[i].x;
			this.sx2 +=sq(this.sample[i].x);
			this.sxy +=(this.sample[i].x*this.sample[i].y);
			this.sy1 +=this.sample[i].y;
		}
		this.beta_hat=(Nobs*this.sxy-this.sx1*this.sy1)/(Nobs*this.sx2-this.sx1*this.sx1);
		this.alpha_hat=(this.sy1-this.beta_hat*this.sx1)/Nobs;
		for (int i=0; i<Nobs; i++) {
			this.sample[i].stats(this.alpha_hat,this.beta_hat,this.sy1);
		}
	}
	
	void plotSample() {
		//plot the sample
		for (int i=0; i<Nobs; i++){
			this.sample[i].display();
		}	
	}
	
	void calcR2() {
		float SSR=0;
		float TSS=0;
		for (i=0; i<Nobs; i++) {
			SSR +=sq(this.sample[i].epsilon);
			TSS +=sq(this.sample[i].center);
		}
		this.R2 = 1.0-(SSR/TSS);
	}

	void showResults() {
		PFont f;
		String msg = "Y = ";
		f = createFont("Arial",16,true); // Arial, 16 point, anti-aliasing on
		textFont(f,16);
		fill(0);
	
		//the line equations
		msg += str(floor(this.alpha_hat*1000)/1000);
		msg += " + ";
		msg += str(floor(this.beta_hat*1000)/1000);
		msg += " * X";
		text(msg, 25, 15, 180, 30);
		// R2
		msg="R2 = ";
		msg +=str(floor(this.R2*1000)/1000);
		text(msg, 25, 45, 160, 30);
	} 
	
	void drawRegLine() {
		// draw regression line
		stroke(140,140,0);
		lineR(0,this.alpha_hat ,width-offset,this.alpha_hat+this.beta_hat*(width-offset) );
	}
}


/////////////////////////////
/////// The sketch  ////////
////////////////////////////

void setup() {
	size(canvasWidth,canvasHeight);
	smooth();
}

void draw() {
	background(230,230,230);
	// draw axes
	drawAxes(10,10);
	
	// New random sample
	if (makeSample) {
		
		data.create(Nobs);
		
		makeSample=false;
	}
			
	//draw the sample
	data.plotSample();
	//draw regression line
	data.drawRegLine();
	//Print info
	data.calcStats();
	data.calcR2();
	data.showResults();
	
}

/////////////////////////////
// Additional Functions  ///
////////////////////////////

void keyPressed() {
	if (key=='n' || key=='N') {
		makeSample=true;
		focusObs=-1;
	}
}

void lineR(float x1,float y1,float x2,float y2) {
	line(x1+offset,height-(y1+offset),x2+offset,height-(y2+offset))
} 

void ellipseR(float x, float y, int a, int b) {
	ellipse(x+offset,height-(y+offset),a,b);
}

void showResults (float a,float b) {
	PFont f;
	String msg = "Y = ";
	
	f = createFont("Arial",16,true); // Arial, 16 point, anti-aliasing on
	textFont(f,16);
	fill(0);
	
	//the line equations
	msg += str(floor(a*1000)/1000);
	msg += " + ";
	msg += str(floor(b*1000)/1000);
	msg += " * X";
	text(msg, 25, 15, 180, 30);
	// R2
	msg="R2 = ";
	msg +=str(floor(R2*1000)/1000);
	text(msg, 25, 45, 160, 30);
} 

void drawAxes(int xtick, int ytick) {
	stroke(204,102,102);
	//X-axis
	strokeWeight(2);
	line(0,height-offset,width,height-offset); //horizontal line
	line(width,height-offset,width-5,height-offset-5);
	line(width,height-offset,width-5,height-offset+5);
	int xjump=int((width-offset)/xtick);
	strokeWeight(1);
	for (int i=1; i<=xtick; i++) {
		lineR(i*xjump,-3,i*xjump,height-3);
	} 
	//Y-axis
	strokeWeight(2);
	line(offset,0,offset,height);              //vertical line
	line(offset,0,offset-5,offset-5);
	line(offset,0,offset+5,offset-5);
	int yjump=int((height-offset)/ytick);
	strokeWeight(1);
	for (int i=1; i<=ytick; i++) {
		lineR(-3,i*yjump,width-3,i*yjump);
	}
} 

float randomGaussian() {
	float R1,R2;
	R1=random();
	R2=random();
	return sqrt(-2*log(R1))*cos(2*PI*R2);
}


void mouseClicked() {
	if (focusObs==-1) {
		for (int i=0; i<Nobs; i++) {
			float d=sqrt(sq(offset+data.sample[i].x-mouseX)+sq(-offset-data.sample[i].y-mouseY+height));
			//println(d);
			if (d<10) {
				data.sample[i].c=255-data.sample[i].c;
				focusObs=i;
				//println(focusObs);
			}
		}
	} else {
				data.sample[focusObs].c=255-data.sample[focusObs].c;
				data.sample[focusObs].x=mouseX-offset;
				data.sample[focusObs].y=height-(mouseY+offset);
				data.sample[focusObs].display();
				focusObs=-1;
				//println(focusObs);
	}
}

