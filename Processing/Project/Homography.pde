// import processing.core.PApplet;
// import processing.core.PVector;
// import Jama.*;

// /**
//  * The Homography class uses a 3x3 matrix to represent the relationship between the
//  * points in the camera and the points in the projected image.
//  * @author Anis Zaman, Keith O'Hara
//  *
//  */
// public class Homography {

//         /**
//          * the 3x3 matrix 
//          */
//         private Matrix H = Matrix.identity(3,3);
        
//         /**
//          * whether to display debug messages
//          */
//         public boolean debug = false; 
        
//         /**
//          * the parent processing sketch
//          */
//         PApplet parent;

//         public Homography(PApplet p){
//                 parent= p;
//         }
        
//     /**
//      * Load the homography from a file
//      * @param filename the homography file
//      */
//         public void loadFile(String filename){
//                 String lines[] = parent.loadStrings(filename);
//                 for (int i=0; i<3; i++){
//                         for (int j=0; j<3; j++){
//                                 H.set(i,j,(Double.parseDouble(lines[i*3+j]))); 
//                         }
//                 }
//         }

//         /**
//          * Estimate the homography between the camera and the projected image using an
//          * array of known correspondences. The four corners of the sketch are good for this.
//          * 
//          * @param cam an array of points in camera coordinates
//          * @param proj an array of points in screen coordinates
//          */
//         public void computeHomography(PVector[] cam, PVector[] proj){
//                 // Creates an array of two times the size of the cam[] array 
//                 double[][] a = new double[2*cam.length][];
                
//                 // Creates the estimation matrix
//                 for (int i = 0; i < cam.length; i++){
//                         double l1 [] = {cam[i].x, cam[i].y, cam[i].z, 0, 0, 0, -cam[i].x*proj[i].x, -cam[i].y*proj[i].x, -proj[i].x};
//                         double l2 [] = {0, 0, 0, cam[i].x, cam[i].y, cam[i].z, -cam[i].x*proj[i].y, -cam[i].y*proj[i].y, -proj[i].y};
//                         a[2*i] = l1;
//                         a[2*i+1] = l2;
//                 }
//                 Matrix A = new Matrix(a);
//                 Matrix T = A.transpose();
//                 Matrix X = T.times(A);

//                 EigenvalueDecomposition E = X.eig();
//                 // Find the eigenvalues and put that in an array
//                 double[] eigenvalues = E.getRealEigenvalues();
//                 // grab the first eigenvalue from the eigenvalues []
//                 double w = eigenvalues[0];
//                 int r = 0;
//                 // Find the minimun eigenvalue
//                 for (int i= 0; i< eigenvalues.length; i++){
//                         if (debug) parent.println(eigenvalues[i]);
//                         if (eigenvalues[i] <= w){
//                                 w = eigenvalues[i];
//                                 r = i;
//                         } 
//                 }
//                 // find the corresponding eigenvector
//                 Matrix v = E.getV();

//                 if (debug) v.print(9,9);
                
//                 // create the homography matrix from the eigenvector v
//                 for (int i = 0; i < 3; i++){
//                         for (int j = 0; j < 3; j++){
//                                 H.set(i, j, v.get(i*3+j, r));
//                         }
//                 }
//         }
        
//         /**
//          *  write the homography matrix to a file
//          * @param outputFile homography file
//          */
//         public void writeFile(String outputFile){
//                 String[] lines = new String[9];
//                 for (int i = 0; i< 3; i++){
//                         for (int j = 0; j< 3; j++){
//                                 lines[i*3+j] =  Double.toString(H.get(i,j));
//                         }
//                 }
//                 parent.saveStrings(outputFile, lines);
//         }

//         /**
//          * Find the screen coordinates of the LaserPoint p by
//          * multiplying the camera coordinates by the homography matrix.
//          * 
//          * @param p the 
//          */
//         public void computeLaserPosition(LaserPoint p){
//                 PVector q = new PVector(p.cx, p.cy);
//                 PVector r = applyHomography(q);
//                 p.px = p.x;
//                 p.py = p.y;
//                 p.x = (int)r.x;
//                 p.y = (int)r.y;
//         }
        
//         /**
//          * Transform a point p by the homography matrix
//          * @param p: PVector to be transformed
//          */
//         public PVector applyHomography(PVector p){
//                 double[][] a = new double[3][1];
//                 a[0][0] = p.x;
//                 a[1][0] = p.y;
//                 a[2][0] = 1;
//                 Matrix D = new Matrix(a);
//                 Matrix U = H.times(D);
//                 Matrix L = U.times(1/U.get(2,0));
//                 PVector p2 = new PVector();
//                 p2.x = (int)L.get(0, 0);
//                 p2.y = (int)L.get(1, 0);
//                 return p2;
//         }
// }
