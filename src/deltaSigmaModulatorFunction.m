%%%%%%%%% TUBITAK UME - Voltage Laboratory %%%%%%%%% 
%   Vildan Mınık - Summer Intern at TUBITAK-UME, Student at Koc University
%       vminik21@ku.edu.tr
%   Yağmur Karaca - STAR Scholar at TUBITAK-UME, Student at Bogazici University
%       yagmur.karaca@std.bogazici.edu.tr
%   
% Input:
%   - u[]: input signal
%
% Output:
%   - v[]: 3 level 1-bit quantized output of modulator (-1, 0, 1)
%
% Behaviour:
%   - The second order delta sigma modulator(*) is modeled in MATLAB environment as a function which takes input signal as input parameters.
%   - The output signal is obtained by using optimized coefficients(**) and equations shown above. 
%   - Then, this output signal is quantized by a threshold which is determined according to the amplitude of the input signal. 
%   - Therefore, the digital-valued output sequence which is the return value of the function is received. 
%
% (*)This model is obtained from the book "Understanding 2nd Order Delta
% Sigma Data Converters" by R. Schreier and G. C. Temes - DOI:10.1002/9781119258308
% (**)Optimized coefficients are recieved form the article "..." by Tezgül Coşkun Öztürk and ... - tezgul.ozturk@tubitak.gov.tr
%
%%
function v=deltaSigmaModulatorFunction(u,deltav)

        %figure;
        hold on;
        duration=0.05;

        
        N=length(u);
        v=zeros(1,N);
        
        a1 = 0.520300986759043; 
        a2 = 0.340376212701186;
        b1 = 0.520300986759043; 
        b2 = 0.340376212701186; 
        b3 = 1;
        c1 = 0.100008079947509; 
        c2 = 1.060358597231937;
        g1 = 0;
        
        inputdisc1 = [0];
        outputdisc1 = [0];
        inputdisc2=[0];
        outputdisc2=[0];
        v=zeros(1,N);
        vout_dac=zeros(1,N);
        %deltav= max(abs(u));
   
        %utrans=ztrans(u);
        for n=2:N

            inputdisc1(n-1)=u(n-1)*b1-a1*vout_dac(n-1);
            outputdisc1(n)=outputdisc1(n-1)+inputdisc1(n-1);
            inputdisc2(n-1)=outputdisc1(n-1)*c1+u(n-1)*b2-vout_dac(n-1)*a2;
            outputdisc2(n)=outputdisc2(n-1)+inputdisc2(n-1);
            k=outputdisc2(n)*c2+u(n)*b3;


            %quantizing
            if k>=deltav
                v(n) = 1;
            elseif k<= -deltav
                v(n) = -1;
            else
                v(n) = 0;
            end
            vout_dac(n)=v(n-1);
        end

        
        % subplot(2,1,1);
        % plot(1:N, u);
        % title('input (u)');
        % ylabel('amplitude');
        % xlabel('time');
        % grid on;
        % hold on;
        % 
        % subplot(2,1,2);
        % stairs(1:N,v);
        % title('delta-sigma modulation output (v)');
        % ylabel('amplitude');
        % xlabel('time');
        % grid on
        % hold on;    
               
end

     