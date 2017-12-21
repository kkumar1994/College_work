% Frequency sampling design plots

[h1,H1,w1] = freq_samp_filt_examp(16,4,1,0.4);
[h2,H2,w2] = freq_samp_filt_examp(16,4,1,0.5);
[h3,H3,w3] = freq_samp_filt_examp(16,4,1,0.6);
[h4,H4,w4] = freq_samp_filt_examp(16,4,1,1.0);
[h1,H1,w1] = freq_samp_filt_examp(16,4,1,0.4);

figure(5)
semilogy(w1,abs(H1),'-',w2,abs(H2),'--',w3,abs(H3),'-.',w4,abs(H4),':','LineWidth',2)
xlabel('freq \omega (rad/sample)'), ylabel('|H(\omega)|')
legend({'\alpha = 0.4','\alpha = 0.5','\alpha = 0.6','\alpha = 1.0'})
title('Frequency sampling design example')

figure(6)
plot(w1,abs(H1),'-',w2,abs(H2),'--',w3,abs(H3),'-.',w4,abs(H4),':','LineWidth',2)
xlabel('freq \omega (rad/sample)'), ylabel('|H(\omega)|')
legend({'\alpha = 0.4','\alpha = 0.5','\alpha = 0.6','\alpha = 1.0'})
title('Frequency sampling design example')



