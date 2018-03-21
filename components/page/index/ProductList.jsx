import React from 'react';
import PropTypes from 'prop-types';
import GridList, { GridListTile, GridListTileBar } from 'material-ui/GridList';
import Icon from 'material-ui/Icon';
import IconButton from 'material-ui/IconButton';
import Typography from 'material-ui/Typography';
import { withStyles } from 'material-ui/styles';
import { connect } from 'react-redux';
import { loadProducts } from '../../../actions';
import ProductItem from './ProductItem';

const styles = theme => ({
    listContainer: {
        listStyle: 'none',
        display: 'grid',
        gridTemplateColumns: 'repeat(auto-fit, 300px)',
        gridGap: '2rem',
        justifyContent: 'space-around',
        padding: 0
    },
    gridList: {
        width: '100%',
        height: '100%',
        [theme.breakpoints.up('md')]: {
            paddingLeft: '15%',
            paddingRight: '15%'
        }
    },
    gridItem: {
        padding: '10px'
    }
});

class ProductList extends React.Component {
    constructor(props) {
        super(props);
    }

    static propTypes = {
        classes: PropTypes.object.isRequired,
        theme: PropTypes.object.isRequired
    }

    render() {
        const { classes, products } = this.props;
        return (
            <GridList cellHeight={180} cols={3} className={classes.gridList}>
                {products.map((product, index) => {
                    return (
                        <GridListTile key={product.id} className={classes.gridItem}>
                            <img src={product.imageUrl} alt={product.imageAlt} />
                            <GridListTileBar
                                title={product.name}
                                actionIcon={
                                    <IconButton color="default" aria-label="Add to shopping cart">
                                        <Icon>add_shopping_cart</Icon>
                                    </IconButton>
                                }
                            />
                        </GridListTile>
                    );
                })}
            </GridList>
        );
    }
}

const mapStateToProps = ({ products, error }) => ({ products, error });

export default connect(mapStateToProps)(withStyles(styles, { withTheme: true })(ProductList));