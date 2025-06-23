library(ggrepel) 
plotPair = function(xcnd,ycnd,xlab='',ylab='',title='',top_label_n =20,pv_thr=0.05,l2fc_thr=1,lim=12,genes){
    # Build a data frame
    cmn <- intersect(rownames(xcnd), rownames(ycnd))
    
    plot_df <- data.frame(
      gene_id = cmn,
      x = xcnd[cmn, "log2FoldChange"],
      y = ycnd[cmn, "log2FoldChange"],
      xpadj = xcnd[cmn, "padj"],
      ypadj = ycnd[cmn, "padj"]
    )
    
    # Add gene names
    plot_df$gene_name <- genes[plot_df$gene_id, "gene_name"]
    
    # Define significance and label criteria
    cols = setNames(c('gray','blue','green','red'),c('none',xlab,ylab,'both'))
    
    sgnx = abs(plot_df$x)>=l2fc_thr & plot_df$xpadj <= pv_thr
    sgnx[is.na(sgnx)] = FALSE
    sgny = abs(plot_df$y)>=l2fc_thr & plot_df$ypadj <= pv_thr
    sgny[is.na(sgny)] = FALSE
    plot_df$significant = 'none'
    plot_df$significant[sgnx] = xlab
    plot_df$significant[sgny] = ylab
    plot_df$significant[sgnx & sgny] = 'both'
    plot_df$significant = factor(plot_df$significant,levels=names(cols))
    sgn_ord = setNames(0:4,c('none',xlab,ylab,'both'))
    plot_df = plot_df[order(sgn_ord[plot_df$significant]),]

    both = plot_df[plot_df$significant=='both',]
    both = both$gene_id[order(abs(both$x)+abs(both$y),decreasing = TRUE)][seq_len(top_label_n)]
    
    gid2label = c(plot_df$gene_id[order(abs(plot_df$x),decreasing = TRUE)[seq_len(top_label_n)]],
                  plot_df$gene_id[order(abs(plot_df$y),decreasing = TRUE)[seq_len(top_label_n)]],
                  both
                 )
    
      plot_df$label <- ifelse(
      plot_df$gene_id %in% gid2label,
      plot_df$gene_name,''
    )
    
    # Plot
    p <- ggplot(plot_df, aes(x = x, y = y,color=significant)) +
      geom_point(shape = 16, size = 2) +
      geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
      geom_vline(xintercept = 0, linetype = "dashed", color = "red") +
      geom_abline(slope = 1, intercept = 0, color = "red", linetype = "dashed") +
      geom_text_repel(aes(label = label), size = 2.5, color = "blue", max.overlaps = Inf) +
      scale_x_continuous(limits = c(-lim, lim)) +
      scale_y_continuous(limits = c(-lim, lim)) +
      theme_minimal() +
      scale_color_manual(values = cols) + 
      labs(
        title = title,
        x = xlab,
        y = ylab,
      )
}