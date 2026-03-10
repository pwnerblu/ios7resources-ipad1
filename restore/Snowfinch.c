#include<stdio.h>
#include<unistd.h>
#include<getopt.h>
#include<stdlib.h>
#include<string.h>

// just a wrapper... just a wrapper


void bundleCheck() {

    printf("[*] Searching for iOS 7.0 bundle...\n");
    // run check
    
    int check = system("[ -d 'iPad1,1_7.0_11A465_Restore' ]");

    if (check == 0) {
    printf("[*] Bundle found, continuing.\n");
    
    } else {
        printf("[-] Could not find bundle, downloading.\n");
        system("curl -L https://archive.org/download/ipad11_7.0_11a465_restore/iPad1%2C1_7.0_11A465_Restore.zip --output iPad1,1_7.0_11A465_Restore.zip");
        system("unzip -q iPad1,1_7.0_11A465_Restore.zip -d iPad1,1_7.0_11A465_Restore");
        system("rm iPad1,1_7.0_11A465_Restore.zip");
    }

}

void helperDFU() {
    printf("\n[*] Press any key when you are ready for DFU mode");
    getchar(); // this thing

    printf("\n[*] Hold HOME and POWER buttons for seconds: \n");
    for (int i = 8; i > 0; i--) {
        printf("Time remaining: %d  \r", i);
        fflush(stdout);
        sleep(1);
    }

    printf("\n[*] Release POWER, keep holding HOME for seconds: \n");
    for (int i = 10; i > 0; i--) {
        printf("Time remaining: %d  \r", i);
        fflush(stdout);
        sleep(1);
    }

    printf("\n[*] Device should now be in DFU mode.\n");
}



int main() {

    printf("SnowfinchRestore - Version 0.1-stable | Script by Turlum25\n");
    fflush(stdout);
    printf("----------------------------------------------------------\n");
    bundleCheck();
    helperDFU();
    printf("iPad 1 haxx\n");
    fflush(stdout);
    system("tools/ipwnder32 -p");
    int restore = system("./tools/idevicerestore -e ./iPad1,1_7.0_11A465_Restore");

    if(restore == 0) {

        printf("[*] Restore successful\n");
        fflush(stdout);

        printf("[*] Done restoring to iOS 7.0 (hopefully)\n");
        fflush(stdout);
        printf("----------------------------------------");

        return 0;

    }

    else {

        printf("[*] Restore failed.\n");
        fflush(stdout);

        printf("[*] Done restoring to iOS 7.0 (hopefully)\n");
        fflush(stdout);
        printf("----------------------------------------");

        return 1;

    }

    

}
