`timescale 1ns / 1ps
module uart(
  input clk,
  input rst,
  input [3:0] bcd0, //ketjegyu szam also helyiertek
  input [3:0] bcd1, //ketjegyu szam felso helyiertek
  output tx_out

);
reg [9:0] bd; //megfelelo bps-releosztashoz kello szam a szamlalonak, 2^9< 883 <2^10 ezert kell 10 bit
reg tx_en; //az utemgenerator kimeneti jele ami 19200Hz-es
reg [26:0] tx_shr; //3*9=27 bit, 9bit karakterenkent, ezert 27 hosszu regiszterben taroljuk a shiftelest
reg [4:0] tx_cntr; //Egyszeruen szamolja epp hanyadik bitnel tartunk, tudjuk mikor ertunk a vegere a shiftelesnek, 2^4< 27 <2^5 ezert 5 bit
reg out_reg; //kimeneti wire-t ehhez assignoljuk
assign tx_out = out_reg; //kimeneti wire assignolasa regiszterhez

always@(posedge clk) begin
  if(rst) begin //reset
    bd <= 0;
    tx_en <= 0;
    tx_shr <= 0;
    tx_cntr <= 26;
    out_reg <= 1;
  end
  else begin //Utemgeneratorral megfelelo frekvenciaju jel keszitese
    if(bd!=833) begin // 833: lasd hazi feladat 3. kiskerdes
      //szimulaciohoz bd-t 2-nek vettem
      bd <= bd + 1;
      tx_en <= 0;
    end
    else begin
      bd <= 0;
      tx_en <= 1;
    end
  end //azon blokk vege, amely megadja engedelyezo jel erteket (atlathatosag kedveert irtam ide)

if(tx_en) begin //Mintavet felfutas
  if(tx_cntr!=26) begin //ezesetben egyszeru shifteles
    out_reg <= tx_shr[0]; //kimenet beallitas, ami epp a shift regiszter 0. bitje

    tx_shr <= tx_shr >> 1; // shifteles
    tx_cntr <= tx_cntr + 1; // eggyel tobb bitet dolgoztunk fel
  end

  else begin
    tx_cntr <= 0; //0. bitnel jarunk innentol (kovetkezo kiirt bit a 0. bit lesz, kovetkezo ciklusban)

    out_reg <= 1; //kimeneten 1, ez az IDLE
    //Innentol shiftelunk, a kovetkezo 27 bitet egyesevel kiirosgatjuk ciklusonkent

    //Elso harom sor adja meg felso szamjegyet, masodik harom az also szamjegyet, aztan kocsi vissza

    tx_shr[0] <= 0; //startbit 0, mert elotte Idle 1
    tx_shr[7:1] <= {3'b011,bcd1[3:0]}; //felso 3 bit hexa 3, also negy bit a szamjegyunk, ASCIIben igy kapjuk meg azt a szamerteket amit szeretnenk
    tx_shr[8] <= 1; //stopbit
    tx_shr[9] <= 0; //start
    tx_shr[16:10]<= {3'b011,bcd0[3:0]}; //hasonloan mint felso jegy

    tx_shr[17] <= 1;
    tx_shr[18] <= 0;
    tx_shr[25:19] <= 7'b0001101; //kocsi-vissza: hexa 0x0d, a meresi utmutatoban igy volt megadva
    tx_shr[26] <= 1;

  end
 end
end //

endmodule
